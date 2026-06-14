#include "mazeengine.h"
#include <QRandomGenerator>
#include <QStack>
#include <QJsonDocument>
#include <QFile>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <QNetworkRequest>

MazeEngine::MazeEngine(QObject *parent)
    : QObject(parent), m_networkManager(new QNetworkAccessManager(this))
{

    m_successSound.setSource(
        QUrl("qrc:/modules/adhd/cognimaze/assets/success.wav"));

    m_wallSound.setSource(
        QUrl("qrc:/modules/adhd/cognimaze/assets/wall.wav"));

    m_bubbleSound.setSource(
        QUrl("qrc:/modules/adhd/cognimaze/assets/bubble.wav"));

    QFile f(":/modules/adhd/cognimaze/assets/wall.wav");

    qDebug() << "Exists:" << f.exists();



    m_successSound.setVolume(0.6f);
    m_wallSound.setVolume(0.4f);
    m_bubbleSound.setVolume(0.5f);

    connect(m_networkManager, &QNetworkAccessManager::finished, this, &MazeEngine::handleNetworkReply);
    setupInitialVariables();
}

MazeEngine::~MazeEngine() = default;

void MazeEngine::setupInitialVariables()
{
    m_playerRow = 0;
    m_playerCol = 0;
    m_wallCollisions = 0;
    m_backtracksCount = 0;
    m_focusIndex = 100;
    m_isSyncing = false;
    
    m_gameStartTime = QDateTime::currentMSecsSinceEpoch();
    m_lastMoveTime = m_gameStartTime;
    m_moveIntervalMs.clear();
    m_eventLogs = QJsonArray();

    m_visitedPath.clear();
    m_visitedPath.push_back(QPoint(0, 0));

    addTelemetryEvent("SESSION_START", "Successfully started tracking", 0, 0);
}

void MazeEngine::setRows(int r) { if (m_rows != r) { m_rows = r; emit rowsChanged(); } }
void MazeEngine::setCols(int c) { if (m_cols != c) { m_cols = c; emit colsChanged(); } }

void MazeEngine::generateNewMaze()
{

    if (m_rows <= 0 || m_cols <= 0) {
        qWarning() << "Invalid maze size:" << m_rows << "x" << m_cols;
        return;
    }
    setupInitialVariables();

    // 1. Initialize matrix
    m_grid.clear();
    m_grid.resize(m_rows);
    for (int r = 0; r < m_rows; ++r) {
        m_grid[r].resize(m_cols);
        for (int c = 0; c < m_cols; ++c) {
            m_grid[r][c].row = r;
            m_grid[r][c].col = c;
        }
    }

    // 2. Perform Randomized DFS with Backtracking (Maze generation)
    QVector<QVector<bool>> visited(m_rows, QVector<bool>(m_cols, false));
    QStack<QPoint> stack;

    visited[0][0] = true;
    stack.push(QPoint(0, 0));

    while (!stack.isEmpty()) {
        QPoint curr = stack.top();
        QVector<std::tuple<int, int, QString>> neighbors;

        int r = curr.x();
        int c = curr.y();

        if (r > 0 && !visited[r - 1][c]) neighbors.push_back({r - 1, c, "top"});
        if (c < m_cols - 1 && !visited[r][c + 1]) neighbors.push_back({r, c + 1, "right"});
        if (r < m_rows - 1 && !visited[r + 1][c]) neighbors.push_back({r + 1, c, "bottom"});
        if (c > 0 && !visited[r][c - 1]) neighbors.push_back({r, c - 1, "left"});

        if (!neighbors.isEmpty()) {
            int idx = QRandomGenerator::global()->bounded(neighbors.size());
            auto [nextR, nextC, dir] = neighbors[idx];

            if (dir == "top") {
                m_grid[r][c].topWall = false;
                m_grid[nextR][nextC].bottomWall = false;
            } else if (dir == "right") {
                m_grid[r][c].rightWall = false;
                m_grid[nextR][nextC].leftWall = false;
            } else if (dir == "bottom") {
                m_grid[r][c].bottomWall = false;
                m_grid[nextR][nextC].topWall = false;
            } else if (dir == "left") {
                m_grid[r][c].leftWall = false;
                m_grid[nextR][nextC].rightWall = false;
            }

            visited[nextR][nextC] = true;
            stack.push(QPoint(nextR, nextC));
        } else {
            stack.pop();
        }
    }

    emit mazeGenerated();
}

bool MazeEngine::checkWall(int row, int col, const QString &direction) const
{
    // if (row < 0 || row >= m_rows || col < 0 || col >= m_cols) return true;
    // const MazeCell &cell = m_grid[row][col];
    // if (direction == "top") return cell.topWall;
    // if (direction == "right") return cell.rightWall;
    // if (direction == "bottom") return cell.bottomWall;
    // if (direction == "left") return cell.leftWall;
    // return true;
    // Validate actual grid

    if (!isMazeReady())
        return true;

    qDebug()
        << "checkWall"
        << row
        << col
        << "grid rows"
        << m_grid.size();

    if (row < 0 || row >= m_grid.size())
        return true;

    if (col < 0 || col >= m_grid[row].size())
        return true;

    const MazeCell &cell = m_grid[row][col];

    if (direction == "top")
        return cell.topWall;

    if (direction == "right")
        return cell.rightWall;

    if (direction == "bottom")
        return cell.bottomWall;

    if (direction == "left")
        return cell.leftWall;

    return true;
}

void MazeEngine::movePlayer(const QString &direction)
{
    int nextRow = m_playerRow;
    int nextCol = m_playerCol;
    bool isBlocked = checkWall(m_playerRow, m_playerCol, direction);

    qint64 now = QDateTime::currentMSecsSinceEpoch();
    m_moveIntervalMs.push_back(now - m_lastMoveTime);
    m_lastMoveTime = now;

    // Handle re-engagement after distraction
    if (m_activeDistractionSpawnTime > 0) {
        qint64 recoveryTime = now - m_activeDistractionSpawnTime;
        m_recoveryTimesMs.push_back(recoveryTime);
        addTelemetryEvent("DISTRACTION_RECOVERY", 
                          QString("Resumed maze movement after %1 ms").arg(recoveryTime), 
                          m_playerRow, m_playerCol);
        m_activeDistractionSpawnTime = 0; // reset
    }

    if (isBlocked) {
        m_wallCollisions++;
        addTelemetryEvent("COLLISION", QString("Hit wall trying to move %1").arg(direction), m_playerRow, m_playerCol);
        emit metricsChanged();
        emit wallCollisionDetected();
        return;
    }

    // Success motion
    if (direction == "top") nextRow--;
    else if (direction == "bottom") nextRow++;
    else if (direction == "left") nextCol--;
    else if (direction == "right") nextCol++;

    QPoint targetPoint(nextRow, nextCol);
    bool backtrack = false;
    
    // Check backtracks count if they back up path
    if (m_visitedPath.size() > 1 && m_visitedPath[m_visitedPath.size() - 2] == targetPoint) {
        m_backtracksCount++;
        backtrack = true;
    }

    m_playerRow = nextRow;
    m_playerCol = nextCol;
    m_visitedPath.push_back(targetPoint);

    if (m_playerRow == m_rows - 1 &&
        m_playerCol == m_cols - 1)
    {
        addTelemetryEvent(
            "MAZE_COMPLETED",
            "Player reached destination",
            m_playerRow,
            m_playerCol);

        emit mazeCompleted();
    }

    QString desc = QString("Moved to (%1,%2)").arg(nextRow).arg(nextCol);
    if (backtrack) desc += " [Backtracked]";
    
    addTelemetryEvent("MOVE", desc, m_playerRow, m_playerCol);
    
    // Compute focus score algorithmically
    computeFocusIndex();
    
    emit playerMoved();
    emit metricsChanged();
}

void MazeEngine::registerDistractionSpawn(int row, int col, const QString &distType)
{
    m_activeDistractionSpawnTime = QDateTime::currentMSecsSinceEpoch();
    m_activeDistractionClicked = false;
    addTelemetryEvent("DISTRACTION_SPAWNED", QString("Visual distraction spawning: %1").arg(distType), row, col);
}

void MazeEngine::registerDistractionInteract(bool clicked)
{
    if (m_activeDistractionSpawnTime <= 0) return;
    qint64 now = QDateTime::currentMSecsSinceEpoch();
    qint64 reactionTime = now - m_activeDistractionSpawnTime;
    
    m_activeDistractionClicked = clicked;
    if (clicked) {
        m_reactionTimesMs.push_back(reactionTime);
        addTelemetryEvent("DISTRACTION_TAP", QString("Child tapped item in %1 ms").arg(reactionTime), m_playerRow, m_playerCol);
    }
}

void MazeEngine::addTelemetryEvent(const QString &type, const QString &details, int row, int col)
{
    QJsonObject ev;
    ev["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODateWithMs);
    ev["type"] = type;
    ev["grid"] = QString("%1,%2").arg(row).arg(col);
    ev["details"] = details;
    m_eventLogs.append(ev);
}

void MazeEngine::computeFocusIndex()
{
    // Strategic formula assessing focus consistency and low impulse ratios
    int penalty = 0;
    
    // Impact of wall bumping representing motor speed rushing / impulsivity
    penalty += qMin(30, m_wallCollisions * 4);
    
    // Impact of spatial recalculation backtracks
    penalty += qMin(20, m_backtracksCount * 3);

    // Speed focus lapse
    if (!m_moveIntervalMs.isEmpty()) {
        qint64 sum = 0;
        for (qint64 val : m_moveIntervalMs) sum += val;
        double avg = (double)sum / m_moveIntervalMs.size();
        if (avg > 2500) penalty += 15; // spatial hesitation penalty
    }

    m_focusIndex = qMax(20, 100 - penalty);
}

void MazeEngine::triggerDataSync(const QString &endpointUrl)
{
    if (m_isSyncing) return;
    m_isSyncing = true;
    emit syncStateChanged();

    // Serialize analytics state to JSON object
    QJsonObject payload;
    payload["userId"] = "cogni_child_active";
    payload["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    payload["rows"] = m_rows;
    payload["cols"] = m_cols;
    payload["focusIndex"] = m_focusIndex;
    payload["wallCollisions"] = m_wallCollisions;
    payload["backtracks"] = m_backtracksCount;
    payload["events"] = m_eventLogs;

    QJsonDocument doc(payload);
    QByteArray data = doc.toJson(QJsonDocument::Compact);

    // // Call standard Qt Network mechanisms
    // QNetworkRequest request(QUrl(endpointUrl));
    // request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    
    // QNetworkReply *reply = m_networkManager->post(request, data);
    // // Connection timeouts
    // reply->setProperty("timeout", 5000);
}

void MazeEngine::handleNetworkReply(QNetworkReply *reply)
{
    m_isSyncing = false;
    emit syncStateChanged();

    if (reply->error() == QNetworkReply::NoError) {
        QString responseContent = reply->readAll();
        emit syncCompleted(true, responseContent);
    } else {
        qWarning() << "C++ Network Error:" << reply->errorString();
        writeOfflineDatabase(); // Save fallback
        emit syncCompleted(false, reply->errorString());
    }
    reply->deleteLater();
}

void MazeEngine::writeOfflineDatabase()
{
    // Write JSON file directly to generic safe system storage paths
    QString writePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(writePath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QFile file(dir.filePath("pending_telemetry.json"));
    if (file.open(QIODevice::WriteOnly)) {
        QJsonObject offlinePayload;
        offlinePayload["cachedAt"] = QDateTime::currentDateTime().toString(Qt::ISODate);
        offlinePayload["focusIndex"] = m_focusIndex;
        file.write(QJsonDocument(offlinePayload).toJson());
        file.close();
        qInfo() << "Offline C++ File sync cached at:" << file.fileName();
    }
}

QString MazeEngine::getDailyPerformanceReport()
{
    // Returns markdown report parsed inside visual reports tab
    QString rpt = QString("# CogniMaze Evaluation Report\\n\\n") +
                   QString("- **Focal Consistency**: %1%\\n").arg(m_focusIndex) +
                   QString("- **Visual Distractors Noted**: %1\\n").arg(m_reactionTimesMs.size()) +
                   QString("- **Spatial Recalibrations (Backtracks)**: %1\\n\\n").arg(m_backtracksCount);
    
    if (m_focusIndex > 80) rpt += "### Recommendation\\nMaintain structured levels daily. Introduce higher sizes.";
    else if (m_focusIndex > 50) rpt += "### Recommendation\\nModerate focus index. Break playtime into 3 min routines.";
    else rpt += "### Recommendation\\nTouch impulsivity logged. Practice physical hand-over-guidance patterns.";
    return rpt;
}

// void MazeEngine::handleWallCollision()
// {
//     ++m_wallCollisions;

//     m_wallSound.play();

//     emit wallCollisionDetected();
// }

void MazeEngine::playSuccessSound()
{
    m_successSound.play();
}

void MazeEngine::playWallCollisionSound()
{
    m_wallSound.play();
}

void MazeEngine::playBubbleSound()
{
    m_bubbleSound.play();
}
bool MazeEngine::isMazeReady()const
{
    return !m_grid.isEmpty()
    && m_grid.size() == m_rows
        && !m_grid[0].isEmpty();
}
bool MazeEngine::mazeReady() const
{
    return !m_grid.isEmpty();
}

// bool MazeEngine::mazeReady() const
// {
//     return m_mazeReady;
// }

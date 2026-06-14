#ifndef MAZEENGINE_H
#define MAZEENGINE_H

#include <QObject>
#include <QPoint>
#include <QVector>
#include <QJsonObject>
#include <QJsonArray>
#include <QDateTime>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QSoundEffect>
#include <QQmlEngine>

struct MazeCell {
    int row;
    int col;
    bool topWall = true;
    bool rightWall = true;
    bool bottomWall = true;
    bool leftWall = true;
};

class MazeEngine : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    // Parent metric properties read/written directly within the QML View
    Q_PROPERTY(int rows READ rows WRITE setRows NOTIFY rowsChanged)
    Q_PROPERTY(int cols READ cols WRITE setCols NOTIFY colsChanged)
    Q_PROPERTY(int playerRow READ playerRow NOTIFY playerMoved)
    Q_PROPERTY(int playerCol READ playerCol NOTIFY playerMoved)
    Q_PROPERTY(int wallCollisions READ wallCollisions NOTIFY metricsChanged)
    Q_PROPERTY(int backtracksCount READ backtracksCount NOTIFY metricsChanged)
    Q_PROPERTY(int focusIndex READ focusIndex NOTIFY metricsChanged)
    Q_PROPERTY(bool isSyncing READ isSyncing NOTIFY syncStateChanged)
    Q_PROPERTY(bool mazeReady READ mazeReady NOTIFY mazeGenerated)

public:
    explicit MazeEngine(QObject *parent = nullptr);
    ~MazeEngine() override;

    // Core Properties Getters
    int rows() const { return m_rows; }
    int cols() const { return m_cols; }
    int playerRow() const { return m_playerRow; }
    int playerCol() const { return m_playerCol; }
    int wallCollisions() const { return m_wallCollisions; }
    int backtracksCount() const { return m_backtracksCount; }
    int focusIndex() const { return m_focusIndex; }
    bool isSyncing() const { return m_isSyncing; }

    // Setters
    void setRows(int r);
    void setCols(int c);

    // QML Callable API Layer - Generates custom randomized mazes
    Q_INVOKABLE void generateNewMaze();
    Q_INVOKABLE bool checkWall(int row, int col, const QString &direction) const;
    Q_INVOKABLE void movePlayer(const QString &direction);
    Q_INVOKABLE void registerDistractionSpawn(int row, int col, const QString &distType);
    Q_INVOKABLE void registerDistractionInteract(bool clicked);
    Q_INVOKABLE void triggerDataSync(const QString &endpointUrl);
    Q_INVOKABLE QString getDailyPerformanceReport();

    Q_INVOKABLE void playSuccessSound();
    Q_INVOKABLE void playWallCollisionSound();
    Q_INVOKABLE void playBubbleSound();

    bool mazeReady() const;

signals:
    // Reactive signals triggering QML layout updates
    void rowsChanged();
    void colsChanged();
    void playerMoved();
    void metricsChanged();
    void syncStateChanged();
    void mazeGenerated();
    void syncCompleted(bool success, const QString &response);
    void wallCollisionDetected();
    void mazeCompleted();


private slots:
    void handleNetworkReply(QNetworkReply *reply);

private:
    void setupInitialVariables();
    void addTelemetryEvent(const QString &type, const QString &details, int row, int col);
    void computeFocusIndex();
    void writeOfflineDatabase();
    bool  isMazeReady() const ;

    // Board Dimensions
    int m_rows = 6;
    int m_cols = 6;
    int m_playerRow = 0;
    int m_playerCol = 0;

    // Heuristics trackers
    int m_wallCollisions = 0;
    int m_backtracksCount = 0;
    int m_focusIndex = 100;
    bool m_isSyncing = false;

    // Grid nodes
    QVector<QVector<MazeCell>> m_grid;
    QVector<QPoint> m_visitedPath;
    
    // Time Related metrics
    qint64 m_gameStartTime = 0;
    qint64 m_lastMoveTime = 0;
    QVector<qint64> m_moveIntervalMs;

    // Distraction records
    qint64 m_activeDistractionSpawnTime = 0;
    bool m_activeDistractionClicked = false;
    QVector<qint64> m_reactionTimesMs;
    QVector<qint64> m_recoveryTimesMs;

    // Log tracking list (compact schema)
    QJsonArray m_eventLogs;

    // Network manager for sending results
    QNetworkAccessManager *m_networkManager;

    QSoundEffect m_successSound;
    QSoundEffect m_wallSound;
    QSoundEffect m_bubbleSound;
    bool m_mazeReady;
};

#endif // MAZEENGINE_H

#include "gameengine.h"

GameEngine::GameEngine(QObject *parent) : QObject(parent) {}

void GameEngine::startGame(int difficulty) {
    m_startTime = QDateTime::currentDateTime();
    m_correctMoves = 0;
    m_failedMoves = 0;
    m_eventLog = QJsonArray();
    
    if (difficulty == 0) m_targetSum = 20;
    else m_targetSum = 100;

    logEvent("game_start", {{"difficulty", difficulty}, {"target_sum", m_targetSum}});
    emit metricsChanged();
}

bool GameEngine::attemptMove(int cardValue1, int cardValue2) {
    bool success = (cardValue1 + cardValue2 == m_targetSum);
    
    QJsonObject event;
    event["card1"] = cardValue1;
    event["card2"] = cardValue2;
    event["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);

    if (success) {
        m_correctMoves++;
        logEvent("move_success", event);
    } else {
        m_failedMoves++;
        logEvent("move_failure", event);
    }

    emit moveResult(success, success ? "Correct!" : "Try again!");
    emit metricsChanged();
    return success;
}

void GameEngine::logEvent(const QString &type, const QJsonObject &data) {
    QJsonObject entry;
    entry["type"] = type;
    entry["data"] = data;
    entry["time"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    m_eventLog.append(entry);
}

QVariantList GameEngine::metrics() const {
    QVariantList list;
    double accuracy = (m_correctMoves + m_failedMoves > 0) 
        ? (double)m_correctMoves / (m_correctMoves + m_failedMoves) * 100 
        : 0;

    list.append(m_correctMoves);
    list.append(m_failedMoves);
    list.append(accuracy);
    return list;
}

void GameEngine::exportMetrics() {
    QJsonObject root;
    root["events"] = m_eventLog;
    root["summary"] = QJsonObject{
        {"correct", m_correctMoves},
        {"failed", m_failedMoves},
        {"accuracy", (m_correctMoves + m_failedMoves > 0) ? (double)m_correctMoves / (m_correctMoves + m_failedMoves) : 0}
    };

    QJsonDocument doc(root);
    QFile file("/home/ubuntu/clumsy_thief/data/metrics.json");
    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson());
        file.close();
    }
}

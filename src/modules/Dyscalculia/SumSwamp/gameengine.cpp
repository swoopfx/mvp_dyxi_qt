#include "gameengine.h"
#include <QDebug>

GameEngine::GameEngine(QObject *parent) : QObject(parent) {
    m_errorTypes["off_by_one"] = 0;
    m_errorTypes["sign_error"] = 0;
    m_errorTypes["other"] = 0;
}

void GameEngine::startSession() {
    m_events = QJsonArray();
    m_correctCount = 0;
    m_totalCount = 0;
    m_totalTime = 0.0;
    m_turnTimer.start();
}

void GameEngine::processAnswer(int num1, QString op, int num2, int userAnswer) {
    qint64 timeTakenMs = m_turnTimer.restart();
    double timeTakenSec = timeTakenMs / 1000.0;
    
    int correctAnswer = (op == "+") ? (num1 + num2) : (num1 - num2);
    bool isCorrect = (userAnswer == correctAnswer);

    m_totalCount++;
    if (isCorrect) {
        m_correctCount++;
    } else {
        // Simple error evaluation
        if (qAbs(userAnswer - correctAnswer) == 1) {
            m_errorTypes["off_by_one"] = m_errorTypes["off_by_one"].toInt() + 1;
        } else if (userAnswer == (num1 + num2) && op == "-") {
            m_errorTypes["sign_error"] = m_errorTypes["sign_error"].toInt() + 1;
        } else {
            m_errorTypes["other"] = m_errorTypes["other"].toInt() + 1;
        }
    }
    m_totalTime += timeTakenSec;

    QJsonObject event;
    event["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    event["num1"] = num1;
    event["op"] = op;
    event["num2"] = num2;
    event["user_answer"] = userAnswer;
    event["correct_answer"] = correctAnswer;
    event["is_correct"] = isCorrect;
    event["time_taken"] = timeTakenSec;
    
    m_events.append(event);
    emit metricsUpdated();
}

double GameEngine::averageSpeed() const {
    return m_totalCount > 0 ? m_totalTime / m_totalCount : 0.0;
}

double GameEngine::accuracy() const {
    return m_totalCount > 0 ? (double)m_correctCount / m_totalCount : 0.0;
}

QVariantMap GameEngine::getMetrics() {
    QVariantMap metrics;
    metrics["average_speed"] = averageSpeed();
    metrics["accuracy"] = accuracy();
    metrics["total_correct"] = m_correctCount;
    metrics["total_failed"] = m_totalCount - m_correctCount;
    metrics["error_evaluation"] = m_errorTypes.toVariantMap();
    return metrics;
}

void GameEngine::saveLog() {
    QJsonObject root;
    root["session_start"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    root["difficulty"] = m_difficulty;
    root["events"] = m_events;
    root["summary"] = QJsonObject::fromVariantMap(getMetrics());

    QJsonDocument doc(root);
    QString fileName = QString("/home/ubuntu/sum_swamp_game/data/log_%1.json")
                        .arg(QDateTime::currentDateTime().toMSecsSinceEpoch());
    QFile file(fileName);
    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson());
        file.close();
        emit logSaved(fileName);
    }
}

#include "gameengine.h"
#include <QRandomGenerator>
#include <QDebug>
#include <QJsonDocument>

GameEngine::GameEngine(QObject *parent) : QObject(parent), m_difficulty("Easy") {
    m_sessionStartTime = QDateTime::currentDateTime();
    rollDice();
}

void GameEngine::setDifficulty(const QString &difficulty) {
    if (m_difficulty != difficulty) {
        m_difficulty = difficulty;
        emit difficultyChanged();
        rollDice();
    }
}

void GameEngine::startFocusSprint() {
    m_focusSprintActive = true;
    m_focusSprintProgress = 0;
    logEvent("TASK_START", {{"task", "Focus Sprint"}});
    rollDice();
}

void GameEngine::rollDice() {
    int diceCount = 3;
    int targetMax = 12;

    if (m_difficulty == "Medium") {
        diceCount = 4;
        targetMax = 20;
    } else if (m_difficulty == "Hard") {
        diceCount = 5;
        targetMax = 50;
    }

    m_target = QRandomGenerator::global()->bounded(1, targetMax + 1);
    m_scoringDice.clear();
    for (int i = 0; i < diceCount; ++i) {
        m_scoringDice.append(QRandomGenerator::global()->bounded(1, 7));
    }

    m_lastRollTime = QDateTime::currentDateTime();
    
    emit targetChanged();
    emit scoringDiceChanged();
    
    QJsonObject data;
    data["target"] = m_target;
    QJsonArray diceArray;
    for(auto d : m_scoringDice) diceArray.append(d.toInt());
    data["dice"] = diceArray;
    logEvent("ROLL", data);
}

bool GameEngine::validateEquation(const QString &equation) {
    m_totalAttempts++;
    double timeTaken = m_lastRollTime.msecsTo(QDateTime::currentDateTime()) / 1000.0;
    m_responseTimes.append(timeTaken);

    // Simple validation logic (In real app, use a math parser or JS engine)
    // For this prototype, we'll assume the frontend sends the calculated result
    // Or we can use QJSEngine for full evaluation.
    
    // Placeholder for actual math logic
    bool isCorrect = false; 
    // ... logic to evaluate equation ...

    QJsonObject data;
    data["equation"] = equation;
    data["is_correct"] = isCorrect;
    data["time_taken"] = timeTaken;
    logEvent("SUBMIT", data);

    if (isCorrect) {
        m_correctCount++;
        if (m_focusSprintActive) {
            m_focusSprintProgress++;
            if (m_focusSprintProgress >= 5) {
                m_focusSprintActive = false;
                logEvent("TASK_COMPLETE", {{"task", "Focus Sprint"}});
            }
        }
    } else {
        if (m_focusSprintActive) {
            m_focusSprintActive = false;
            m_focusSprintProgress = 0;
            logEvent("TASK_FAILED", {{"task", "Focus Sprint"}});
        }
    }
    return isCorrect;
}

void GameEngine::logEvent(const QString &type, const QJsonObject &data) {
    QJsonObject event;
    event["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    event["type"] = type;
    event["data"] = data;
    
    emit eventLogged(event);
    
    // Save to file
    QFile file("logs/game_log.json");
    if (file.open(QIODevice::Append | QIODevice::Text)) {
        file.write(QJsonDocument(event).toJson(QJsonDocument::Compact) + "\n");
        file.close();
    }
}

double GameEngine::calculateConcentration() {
    if (m_responseTimes.size() < 2) return 100.0;
    
    double sum = 0;
    for (double t : m_responseTimes) sum += t;
    double mean = sum / m_responseTimes.size();
    
    double sq_sum = 0;
    for (double t : m_responseTimes) sq_sum += (t - mean) * (t - mean);
    double stdev = std::sqrt(sq_sum / m_responseTimes.size());
    
    // Higher concentration if variance is low
    return std::max(0.0, 100.0 - (stdev * 10.0)); 
}

QJsonObject GameEngine::getMetrics() {
    QJsonObject metrics;
    metrics["accuracy"] = m_totalAttempts > 0 ? (double)m_correctCount / m_totalAttempts : 0;
    metrics["concentration"] = calculateConcentration();
    metrics["total_correct"] = m_correctCount;
    metrics["total_failed"] = m_totalAttempts - m_correctCount;
    
    double totalTime = m_sessionStartTime.msecsTo(QDateTime::currentDateTime()) / 60000.0; // minutes
    metrics["frequency"] = totalTime > 0 ? m_totalAttempts / totalTime : 0;
    
    return metrics;
}

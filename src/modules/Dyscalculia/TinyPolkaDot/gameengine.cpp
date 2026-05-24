#include "gameengine.h"
#include <QtMath>

GameEngine::GameEngine(QObject *parent) : QObject(parent)
{
}

double GameEngine::accuracy() const
{
    int total = m_correctCount + m_failCount;
    return total > 0 ? (static_cast<double>(m_correctCount) / total) * 100.0 : 0.0;
}

double GameEngine::avgSpeed() const
{
    if (m_solveTimes.isEmpty()) return 0.0;
    double sum = 0;
    for (int t : m_solveTimes) sum += t;
    return (sum / m_solveTimes.size()) / 1000.0; // in seconds
}

double GameEngine::concentrationScore() const
{
    if (m_timestamps.size() < 2) return 100.0;
    
    // Calculate variance in time between actions as a proxy for concentration
    double meanInterval = 0;
    QList<double> intervals;
    for (int i = 1; i < m_timestamps.size(); ++i) {
        double interval = m_timestamps[i] - m_timestamps[i-1];
        intervals.append(interval);
        meanInterval += interval;
    }
    meanInterval /= intervals.size();
    
    double variance = 0;
    for (double interval : intervals) {
        variance += qPow(interval - meanInterval, 2);
    }
    variance /= intervals.size();
    
    // Lower variance = higher concentration (more steady rhythm)
    // Normalize to 0-100 scale (this is a heuristic)
    double score = 100.0 - (qSqrt(variance) / 100.0);
    return qBound(0.0, score, 100.0);
}

void GameEngine::startGame(const QString &difficulty)
{
    m_currentDifficulty = difficulty;
    m_score = 0;
    m_correctCount = 0;
    m_failCount = 0;
    m_solveTimes.clear();
    m_timestamps.clear();
    m_activityLog = QJsonArray();
    m_sessionStart = QDateTime::currentDateTime();
    m_timestamps.append(m_sessionStart.toMSecsSinceEpoch());
    
    QJsonObject startEvent;
    startEvent["timestamp"] = m_sessionStart.toString(Qt::ISODate);
    startEvent["event"] = "game_start";
    startEvent["difficulty"] = difficulty;
    m_activityLog.append(startEvent);
    
    emit scoreChanged();
    emit metricsChanged();
}

void GameEngine::logEvent(const QString &eventType, const QJsonObject &details)
{
    QJsonObject event;
    event["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    event["event"] = eventType;
    event["details"] = details;
    m_activityLog.append(event);
}

void GameEngine::recordMatch(bool correct, int timeMs)
{
    m_timestamps.append(QDateTime::currentDateTime().toMSecsSinceEpoch());
    if (correct) {
        m_correctCount++;
        m_score += 10;
    } else {
        m_failCount++;
    }
    m_solveTimes.append(timeMs);
    
    QJsonObject matchEvent;
    matchEvent["correct"] = correct;
    matchEvent["time_ms"] = timeMs;
    logEvent("match_attempt", matchEvent);
    
    emit scoreChanged();
    emit metricsChanged();
}

void GameEngine::saveSessionData()
{
    QJsonObject summary;
    summary["session_start"] = m_sessionStart.toString(Qt::ISODate);
    summary["session_end"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    summary["difficulty"] = m_currentDifficulty;
    summary["total_correct"] = m_correctCount;
    summary["total_failed"] = m_failCount;
    summary["accuracy"] = accuracy();
    summary["avg_speed_seconds"] = avgSpeed();
    summary["activity_log"] = m_activityLog;

    QJsonDocument doc(summary);
    QFile file("session_data.json");
    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson());
        file.close();
    }
    
    emit gameFinished(summary);
}

#include "telemetrybackend.h"

TelemetryBackend::TelemetryBackend(QObject *parent)
    : QObject(parent),
      m_totalTries(0),
      m_totalCorrect(0),
      m_totalFailed(0),
      m_creativeIndex(100.0),
      m_problemSolvingIndex(100.0),
      m_speedIndex(100.0),
      m_averageCorrectTime(0.0),
      m_averageFailedTime(0.0)
{
    m_soundSelect.setSource(QUrl("qrc:/assets/audio/select.wav"));
    m_soundSelect.setVolume(0.65f);

    m_soundCorrect.setSource(QUrl("qrc:/assets/audio/correct.wav"));
    m_soundCorrect.setVolume(0.80f);

    m_soundFail.setSource(QUrl("qrc:/assets/audio/fail.wav"));
    m_soundFail.setVolume(0.75f);
}

void TelemetryBackend::logMatch(const QString &shapeName, const QString &shapeType, bool success, double durationMs, double selectToMatchMs)
{
    m_totalTries++;
    if (success) {
        m_totalCorrect++;
        m_matchDurations.append(durationMs);
        emit matchSuccessToast(shapeName);
    } else {
        m_totalFailed++;
        m_failedDurations.append(durationMs);
        emit matchFailToast(shapeName);
    }

    QJsonObject matchEvt;
    matchEvt["id"] = QString("match_%1").arg(QDateTime::currentMSecsSinceEpoch());
    matchEvt["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    matchEvt["shapeName"] = shapeName;
    matchEvt["shapeType"] = shapeType;
    matchEvt["success"] = success;
    matchEvt["durationMs"] = durationMs;
    matchEvt["selectionToMatchGapMs"] = selectToMatchMs;
    m_matchEvents.append(matchEvt);

    recomputeIndices();
}

void TelemetryBackend::logPress(double durationMs, const QString &direction, double distance)
{
    QJsonObject pressEvt;
    pressEvt["time_pressed_down"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    pressEvt["duration_of_press"] = durationMs;
    pressEvt["direction_of_motion"] = direction;
    pressEvt["drag_distance"] = distance;
    m_pressDownEvents.append(pressEvt);

    recomputeIndices();
}

void TelemetryBackend::recomputeIndices()
{
    // C++ analytical computation of user task metrics
    if (m_totalTries > 0) {
        m_problemSolvingIndex = qMax(10.0, qMin(100.0, ((double)m_totalCorrect / m_totalTries) * 100.0 - (m_totalFailed * 2.5)));
    } else {
        m_problemSolvingIndex = 100.0;
    }

    double sumCorrect = 0.0;
    for (const QVariant &val : m_matchDurations) {
        sumCorrect += val.toDouble();
    }
    m_averageCorrectTime = m_totalCorrect > 0 ? (sumCorrect / m_totalCorrect) : 0.0;

    double sumFailed = 0.0;
    for (const QVariant &val : m_failedDurations) {
        sumFailed += val.toDouble();
    }
    m_averageFailedTime = m_totalFailed > 0 ? (sumFailed / m_totalFailed) : 0.0;

    double avgSec = m_totalCorrect > 0 ? (m_averageCorrectTime / 1000.0) : 5.0;
    m_speedIndex = qMax(15.0, qMin(100.0, 100.0 - (avgSec * 6.5)));

    int numClicks = m_pressDownEvents.size();
    m_creativeIndex = qMax(20.0, qMin(100.0, 50.0 + (numClicks * 2.5) - (m_totalFailed * 1.5)));

    emit telemetryUpdated();
}

QString TelemetryBackend::getTelemetryJson() const
{
    QJsonObject root;
    
    QJsonArray matchDurationsArray;
    for (const QVariant &val : m_matchDurations) {
        matchDurationsArray.append(val.toDouble());
    }

    root["duration_of_match"] = matchDurationsArray;
    root["average_time_correct_match"] = m_averageCorrectTime;
    root["average_time_failed_match"] = m_averageFailedTime;
    root["total_failed_matches"] = m_totalFailed;
    root["total_correct_matches"] = m_totalCorrect;
    root["total_tries"] = m_totalTries;
    root["total_game_time"] = 0.0; // Managed by QML timer
    root["press_down_events"] = m_pressDownEvents;
    root["match_log_history"] = m_matchEvents;

    QJsonObject indices;
    indices["creative_index"] = m_creativeIndex;
    indices["problem_solving_index"] = m_problemSolvingIndex;
    indices["speed_index"] = m_speedIndex;
    root["derived_indices"] = indices;

    QJsonDocument doc(root);
    return doc.toJson(QJsonDocument::Indented);
}

void TelemetryBackend::resetTelemetry()
{
    m_totalTries = 0;
    m_totalCorrect = 0;
    m_totalFailed = 0;
    m_creativeIndex = 100.0;
    m_problemSolvingIndex = 100.0;
    m_speedIndex = 100.0;
    m_averageCorrectTime = 0.0;
    m_averageFailedTime = 0.0;

    m_matchDurations.clear();
    m_failedDurations.clear();
    
    while (m_pressDownEvents.size() > 0) m_pressDownEvents.removeAt(0);
    while (m_matchEvents.size() > 0) m_matchEvents.removeAt(0);

    emit telemetryUpdated();
}

void TelemetryBackend::playSelect()
{
    m_soundSelect.play();
}

void TelemetryBackend::playCorrect()
{
    m_soundCorrect.play();
}

void TelemetryBackend::playFail()
{
    m_soundFail.play();
}

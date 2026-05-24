#include "metrictracker.h"
#include <QJsonDocument>
#include <QDebug>
#include <cmath>

MetricTracker::MetricTracker(QObject *parent) : QObject(parent) {
    m_lastQuestionTime = QDateTime::currentMSecsSinceEpoch();
}

void MetricTracker::logEvent(const QString &type, const QVariantMap &data) {
    qint64 currentTime = QDateTime::currentMSecsSinceEpoch();
    QJsonObject event;
    event["timestamp"] = QDateTime::fromMSecsSinceEpoch(currentTime).toString(Qt::ISODate);
    event["type"] = type;
    
    QJsonObject eventData = QJsonObject::fromVariantMap(data);

    if (type == "question_asked") {
        double relativeTime = (m_lastQuestionTime == 0) ? 0 : (currentTime - m_lastQuestionTime) / 1000.0;
        eventData["relative_time_to_previous_question"] = relativeTime;
        m_lastQuestionTime = currentTime;
    } 
    else if (type == "answer_submitted") {
        double timeToAnswer = (currentTime - m_lastQuestionTime) / 1000.0;
        eventData["time_to_answer_relative_to_question"] = timeToAnswer;
        
        bool correct = data["correct"].toBool();
        m_total++;
        if (correct) {
            m_correct++;
        } else {
            m_failed++;
        }
        
        m_totalResponseTime += timeToAnswer;
        m_responseTimes.append(timeToAnswer);
        m_lastAnswerTime = currentTime;
        
        // Add evaluation indices to this specific event log
        eventData["evaluation_indices"] = QJsonObject{
            {"number_sense_index", numberSenseIndex()},
            {"mental_math_speed_index", mentalMathSpeedIndex()},
            {"concentration_index", concentrationIndex()}
        };
        
        emit metricsChanged();
    }

    event["data"] = eventData;
    m_events.append(event);
}

double MetricTracker::numberSenseIndex() const {
    // Accuracy weighted by difficulty (simplified)
    return m_total > 0 ? (double)m_correct / m_total : 0;
}

double MetricTracker::mentalMathSpeedIndex() const {
    // Rate of response: correct answers per second
    return m_totalResponseTime > 0 ? (double)m_correct / m_totalResponseTime : 0;
}

double MetricTracker::concentrationIndex() const {
    if (m_responseTimes.size() < 2) return 1.0;
    
    // Concentration calculated by the stability of response times (inverse of variance)
    double mean = m_totalResponseTime / m_responseTimes.size();
    double sumSqDiff = 0;
    for (int i = 0; i < m_responseTimes.size(); ++i) {
        double val = m_responseTimes[i].toDouble();
        sumSqDiff += std::pow(val - mean, 2);
    }
    double variance = sumSqDiff / m_responseTimes.size();
    
    // Higher stability (lower variance) means higher concentration
    return 1.0 / (1.0 + variance);
}

void MetricTracker::saveLog(const QString &filePath) {
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly)) {
        QJsonObject root;
        root["session_summary"] = QJsonObject{
            {"total_questions", m_total},
            {"correct_count", m_correct},
            {"failed_count", m_failed},
            {"final_number_sense_index", numberSenseIndex()},
            {"final_mental_math_speed_index", mentalMathSpeedIndex()},
            {"final_concentration_index", concentrationIndex()}
        };
        root["events"] = m_events;
        
        QJsonDocument doc(root);
        file.write(doc.toJson());
        file.close();
    }
}

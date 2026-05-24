#include "metricsengine.h"
#include <QtMath>

MetricsEngine::MetricsEngine(QObject *parent)
    : QObject(parent), m_correctCount(0), m_failedCount(0), m_totalQuestions(0)
{
}

double MetricsEngine::accuracy() const
{
    return m_totalQuestions == 0 ? 0 : (double)m_correctCount / m_totalQuestions;
}

double MetricsEngine::mentalMathSpeedIndex() const
{
    if (m_responseTimes.isEmpty()) return 0;
    qint64 totalTime = 0;
    for (qint64 t : m_responseTimes) totalTime += t;
    double avgResponseTime = (double)totalTime / m_responseTimes.size();
    // Index: 10.0 is perfect (instant), decreases as time increases
    return qMax(0.0, 10.0 - (avgResponseTime / 1000.0)); 
}

double MetricsEngine::concentrationIndex() const
{
    if (m_responseTimes.size() < 2) return 10.0;
    // Calculated by consistency of response times (lower variance = higher concentration)
    qint64 totalTime = 0;
    for (qint64 t : m_responseTimes) totalTime += t;
    double mean = (double)totalTime / m_responseTimes.size();
    double variance = 0;
    for (qint64 t : m_responseTimes) variance += qPow(t - mean, 2);
    variance /= m_responseTimes.size();
    double stdDev = qSqrt(variance);
    return qMax(0.0, 10.0 - (stdDev / 500.0));
}

double MetricsEngine::numberSenseIndex() const
{
    // Combination of accuracy and speed
    return (accuracy() * 7.0) + (mentalMathSpeedIndex() * 0.3);
}

void MetricsEngine::onQuestionAsked(int value, QDateTime time)
{
    Q_UNUSED(value);
    m_lastQuestionTime = time;
    m_totalQuestions++;
}

void MetricsEngine::onAnswerSubmitted(bool success, int value, QDateTime time)
{
    Q_UNUSED(value);
    if (success) {
        m_correctCount++;
        if (m_lastQuestionTime.isValid()) {
            m_responseTimes.append(m_lastQuestionTime.msecsTo(time));
        }
    } else {
        m_failedCount++;
    }
    emit metricsUpdated();
}

QVariantMap MetricsEngine::getSummary() const
{
    QVariantMap summary;
    summary["correct_count"] = m_correctCount;
    summary["failed_count"] = m_failedCount;
    summary["accuracy"] = accuracy();
    summary["mental_math_speed_index"] = mentalMathSpeedIndex();
    summary["concentration_index"] = concentrationIndex();
    summary["number_sense_index"] = numberSenseIndex();
    return summary;
}

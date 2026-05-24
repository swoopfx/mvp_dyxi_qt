#ifndef METRICSTRACKER_H
#define METRICSTRACKER_H

#include <QObject>
#include <QList>
#include <QDateTime>
#include <numeric>

class MetricsTracker : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double accuracy READ accuracy NOTIFY metricsUpdated)
    Q_PROPERTY(double avgSpeed READ avgSpeed NOTIFY metricsUpdated)
    Q_PROPERTY(int totalCorrect READ totalCorrect NOTIFY metricsUpdated)
    Q_PROPERTY(int totalFailed READ totalFailed NOTIFY metricsUpdated)
    Q_PROPERTY(double concentration READ concentration NOTIFY metricsUpdated)

public:
    explicit MetricsTracker(QObject *parent = nullptr)
        : QObject(parent), m_totalCorrect(0), m_totalFailed(0) {}

    void recordAttempt(bool correct, qint64 durationMs) {
        if (correct) {
            m_totalCorrect++;
            m_durations.append(durationMs);
        } else {
            m_totalFailed++;
        }
        emit metricsUpdated();
    }

    double accuracy() const {
        int total = m_totalCorrect + m_totalFailed;
        return total == 0 ? 0 : (double)m_totalCorrect / total;
    }

    double avgSpeed() const {
        if (m_durations.isEmpty()) return 0;
        double sum = std::accumulate(m_durations.begin(), m_durations.end(), 0.0);
        return sum / m_durations.size() / 1000.0; // seconds
    }

    int totalCorrect() const { return m_totalCorrect; }
    int totalFailed() const { return m_totalFailed; }

    double concentration() const {
        // Simple heuristic: low variance in response time suggests high concentration
        if (m_durations.size() < 2) return 1.0;
        double mean = avgSpeed() * 1000.0;
        double sq_sum = 0;
        for(qint64 d : m_durations) sq_sum += (d - mean) * (d - mean);
        double variance = sq_sum / m_durations.size();
        // Normalize: 0 to 1, where 1 is high concentration (low variance)
        return qMax(0.0, 1.0 - (qSqrt(variance) / mean));
    }

signals:
    void metricsUpdated();

private:
    int m_totalCorrect;
    int m_totalFailed;
    QList<qint64> m_durations;
};

#endif // METRICSTRACKER_H

#ifndef METRICTRACKER_H
#define METRICTRACKER_H

#include <QObject>
#include <QDateTime>
#include <QVariantList>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>

class MetricTracker : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int correctCount READ correctCount NOTIFY metricsChanged)
    Q_PROPERTY(int failedCount READ failedCount NOTIFY metricsChanged)
    Q_PROPERTY(double numberSenseIndex READ numberSenseIndex NOTIFY metricsChanged)
    Q_PROPERTY(double mentalMathSpeedIndex READ mentalMathSpeedIndex NOTIFY metricsChanged)
    Q_PROPERTY(double concentrationIndex READ concentrationIndex NOTIFY metricsChanged)

public:
    explicit MetricTracker(QObject *parent = nullptr);

    Q_INVOKABLE void logEvent(const QString &type, const QVariantMap &data);
    Q_INVOKABLE void saveLog(const QString &filePath);
    
    int correctCount() const { return m_correct; }
    int failedCount() const { return m_failed; }
    
    double numberSenseIndex() const;
    double mentalMathSpeedIndex() const;
    double concentrationIndex() const;

signals:
    void metricsChanged();

private:
    QJsonArray m_events;
    int m_correct = 0;
    int m_failed = 0;
    int m_total = 0;
    double m_totalResponseTime = 0;
    qint64 m_lastQuestionTime = 0;
    qint64 m_lastAnswerTime = 0;
    
    QJsonArray m_responseTimes;
};

#endif // METRICTRACKER_H

#ifndef METRICSENGINE_H
#define METRICSENGINE_H

#include <QObject>
#include <QDateTime>
#include <QVariantMap>
#include <QQmlEngine>

class MetricsEngine : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(double accuracy READ accuracy NOTIFY metricsUpdated)
    Q_PROPERTY(double mentalMathSpeedIndex READ mentalMathSpeedIndex NOTIFY metricsUpdated)
    Q_PROPERTY(double concentrationIndex READ concentrationIndex NOTIFY metricsUpdated)
    Q_PROPERTY(double numberSenseIndex READ numberSenseIndex NOTIFY metricsUpdated)

public:
    explicit MetricsEngine(QObject *parent = nullptr);

    double accuracy() const;
    double mentalMathSpeedIndex() const;
    double concentrationIndex() const;
    double numberSenseIndex() const;

    Q_INVOKABLE QVariantMap getSummary() const;

public slots:
    void onQuestionAsked(int value, QDateTime time);
    void onAnswerSubmitted(bool success, int value, QDateTime time);

signals:
    void metricsUpdated();

private:
    int m_correctCount;
    int m_failedCount;
    int m_totalQuestions;
    QDateTime m_lastQuestionTime;
    QList<qint64> m_responseTimes;
    
    void calculateIndices();
};

#endif // METRICSENGINE_H

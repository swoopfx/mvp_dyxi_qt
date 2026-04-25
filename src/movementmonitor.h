#ifndef MOVEMENTMONITOR_H
#define MOVEMENTMONITOR_H

#include <QObject>
#include <QPointF>
#include <QVector>
#include <QString>
#include <QJsonObject>

struct MovementMetrics {
    qreal averageSpeed;
    qreal maxSpeed;
    qreal minSpeed;
    qreal speedVariance;
    qreal averagePressure;
    qreal maxPressure;
    qreal minPressure;
    int strokeCount;
    int clickCount;
    qint64 totalDuration;
    qreal pathDeviation;
    qreal completionPercentage;
};

class MovementMonitor : public QObject
{
    Q_OBJECT

public:
    explicit MovementMonitor(QObject *parent = nullptr);

    Q_INVOKABLE void startTracking();
    Q_INVOKABLE void stopTracking();
    Q_INVOKABLE void recordPoint(qreal x, qreal y, qreal pressure);
    Q_INVOKABLE void recordClick();
    Q_INVOKABLE MovementMetrics calculateMetrics();
    Q_INVOKABLE QJsonObject getMetricsAsJson();
    Q_INVOKABLE void reset();

    MovementMetrics getMetrics() const { return m_metrics; }

signals:
    void metricsUpdated();
    void trackingStarted();
    void trackingStopped();

private:
    struct Point {
        QPointF position;
        qreal pressure;
        qint64 timestamp;
    };

    QVector<Point> m_points;
    MovementMetrics m_metrics;
    qint64 m_startTime;
    bool m_isTracking;
    int m_clickCount;

    qreal calculateSpeed(const Point &p1, const Point &p2);
    qreal calculateVariance(const QVector<qreal> &values);
};

#endif // MOVEMENTMONITOR_H

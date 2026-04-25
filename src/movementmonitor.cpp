#include "movementmonitor.h"
#include <QJsonObject>
#include <QJsonArray>
#include <QDateTime>
#include <cmath>
#include <numeric>
#include <algorithm>

MovementMonitor::MovementMonitor(QObject *parent)
    : QObject(parent), m_startTime(0), m_isTracking(false), m_clickCount(0)
{
    m_metrics = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
}

void MovementMonitor::startTracking()
{
    m_isTracking = true;
    m_startTime = QDateTime::currentMSecsSinceEpoch();
    m_points.clear();
    m_clickCount = 0;
    emit trackingStarted();
}

void MovementMonitor::stopTracking()
{
    m_isTracking = false;
    emit trackingStopped();
}

void MovementMonitor::recordPoint(qreal x, qreal y, qreal pressure)
{
    if (!m_isTracking)
        return;

    Point p;
    p.position = QPointF(x, y);
    p.pressure = pressure;
    p.timestamp = QDateTime::currentMSecsSinceEpoch();

    m_points.append(p);
}

void MovementMonitor::recordClick()
{
    if (m_isTracking)
        m_clickCount++;
}

MovementMetrics MovementMonitor::calculateMetrics()
{
    MovementMetrics metrics = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

    if (m_points.isEmpty())
        return metrics;

    // Calculate speeds
    QVector<qreal> speeds;
    for (int i = 1; i < m_points.size(); ++i) {
        qreal speed = calculateSpeed(m_points[i-1], m_points[i]);
        speeds.append(speed);
    }

    if (!speeds.isEmpty()) {
        metrics.averageSpeed = std::accumulate(speeds.begin(), speeds.end(), 0.0) / speeds.size();
        metrics.maxSpeed = *std::max_element(speeds.begin(), speeds.end());
        metrics.minSpeed = *std::min_element(speeds.begin(), speeds.end());
        metrics.speedVariance = calculateVariance(speeds);
    }

    // Calculate pressure metrics
    QVector<qreal> pressures;
    for (const auto &p : m_points) {
        pressures.append(p.pressure);
    }

    if (!pressures.isEmpty()) {
        metrics.averagePressure = std::accumulate(pressures.begin(), pressures.end(), 0.0) / pressures.size();
        metrics.maxPressure = *std::max_element(pressures.begin(), pressures.end());
        metrics.minPressure = *std::min_element(pressures.begin(), pressures.end());
    }

    // Count strokes (gaps in movement)
    metrics.strokeCount = 1;
    for (int i = 1; i < m_points.size(); ++i) {
        qint64 timeDiff = m_points[i].timestamp - m_points[i-1].timestamp;
        if (timeDiff > 200) { // 200ms gap indicates new stroke
            metrics.strokeCount++;
        }
    }

    metrics.clickCount = m_clickCount;
    metrics.totalDuration = m_points.last().timestamp - m_points.first().timestamp;

    m_metrics = metrics;
    emit metricsUpdated();

    return metrics;
}

QJsonObject MovementMonitor::getMetricsAsJson()
{
    MovementMetrics m = calculateMetrics();

    QJsonObject json;
    json["averageSpeed"] = m.averageSpeed;
    json["maxSpeed"] = m.maxSpeed;
    json["minSpeed"] = m.minSpeed;
    json["speedVariance"] = m.speedVariance;
    json["averagePressure"] = m.averagePressure;
    json["maxPressure"] = m.maxPressure;
    json["minPressure"] = m.minPressure;
    json["strokeCount"] = m.strokeCount;
    json["clickCount"] = m.clickCount;
    json["totalDuration"] = static_cast<int>(m.totalDuration);
    json["pathDeviation"] = m.pathDeviation;
    json["completionPercentage"] = m.completionPercentage;

    return json;
}

void MovementMonitor::reset()
{
    m_points.clear();
    m_clickCount = 0;
    m_metrics = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
}

qreal MovementMonitor::calculateSpeed(const Point &p1, const Point &p2)
{
    qreal dx = p2.position.x() - p1.position.x();
    qreal dy = p2.position.y() - p1.position.y();
    qreal distance = std::sqrt(dx * dx + dy * dy);

    qint64 timeDiff = p2.timestamp - p1.timestamp;
    if (timeDiff == 0)
        return 0;

    return distance / (timeDiff / 1000.0); // pixels per second
}

qreal MovementMonitor::calculateVariance(const QVector<qreal> &values)
{
    if (values.isEmpty())
        return 0;

    qreal mean = std::accumulate(values.begin(), values.end(), 0.0) / values.size();
    qreal variance = 0;

    for (qreal v : values) {
        variance += (v - mean) * (v - mean);
    }

    return variance / values.size();
}

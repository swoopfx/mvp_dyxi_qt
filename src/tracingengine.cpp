#include "tracingengine.h"
#include <QDebug>
#include <cmath>
#include <QDateTime>

TracingEngine::TracingEngine(QObject *parent)
    : QObject(parent), m_isTracing(false)
{
    initializeLetterTemplates();
}

bool TracingEngine::isTracing() const
{
    return m_isTracing;
}

void TracingEngine::setIsTracing(bool tracing)
{
    if (m_isTracing != tracing) {
        m_isTracing = tracing;
        emit isTracingChanged();
    }
}

QString TracingEngine::currentLetter() const
{
    return m_currentLetter;
}

void TracingEngine::setCurrentLetter(const QString &letter)
{
    if (m_currentLetter != letter) {
        m_currentLetter = letter;
        m_currentTrace.clear();
        emit currentLetterChanged();
    }
}

int TracingEngine::traceProgress() const
{
    if (m_currentTrace.isEmpty())
        return 0;
    return static_cast<int>((m_currentTrace.size() / 100.0) * 100);
}

void TracingEngine::addTracePoint(qreal x, qreal y, qreal pressure)
{
    if (!m_isTracing)
        return;

    TracePoint point;
    point.position = QPointF(x, y);
    point.pressure = pressure;
    point.timestamp = QDateTime::currentMSecsSinceEpoch();

    if (!m_currentTrace.isEmpty()) {
        const TracePoint &lastPoint = m_currentTrace.last();
        qreal distance = calculateDistance(lastPoint.position, point.position);
        qreal timeDiff = static_cast<qreal>(point.timestamp - lastPoint.timestamp) / 1000.0;
        point.speed = (timeDiff > 0) ? distance / timeDiff : 0;
    } else {
        point.speed = 0;
    }

    m_currentTrace.append(point);
    emit tracePointAdded(x, y);
    emit traceProgressChanged();
}

void TracingEngine::resetTrace()
{
    m_currentTrace.clear();
    emit traceProgressChanged();
}

bool TracingEngine::validateTrace()
{
    if (m_currentTrace.isEmpty())
        return false;

    // Find the ideal path for current letter
    QVector<QPointF> idealPath;
    for (const auto &tmpl : m_letterTemplates) {
        if (tmpl.letter == m_currentLetter) {
            idealPath = tmpl.idealPath;
            break;
        }
    }

    if (idealPath.isEmpty())
        return false;

    // Calculate deviation from ideal path
    qreal deviation = calculateDeviation(m_currentTrace, idealPath);

    // Validation criteria:
    // - Deviation should be less than tolerance
    // - Trace should have minimum number of points
    // - Pressure should be consistent

    const qreal maxDeviation = 50.0; // pixels
    const int minPoints = 10;

    bool isValid = (deviation < maxDeviation) && (m_currentTrace.size() >= minPoints);

    if (isValid) {
        emit traceValid();
    } else {
        emit traceInvalid();
    }

    return isValid;
}

QVector<QPointF> TracingEngine::getIdealPath(const QString &letter)
{
    for (const auto &tmpl : m_letterTemplates) {
        if (tmpl.letter == letter) {
            return tmpl.idealPath;
        }
    }
    return QVector<QPointF>();
}

QVector<QPointF> TracingEngine::getCurrentTrace() const
{
    QVector<QPointF> result;
    for (const auto &point : m_currentTrace) {
        result.append(point.position);
    }
    return result;
}

qreal TracingEngine::calculateDistance(const QPointF &p1, const QPointF &p2)
{
    qreal dx = p2.x() - p1.x();
    qreal dy = p2.y() - p1.y();
    return std::sqrt(dx * dx + dy * dy);
}

qreal TracingEngine::calculateDeviation(const QVector<TracePoint> &trace, const QVector<QPointF> &idealPath)
{
    if (trace.isEmpty() || idealPath.isEmpty())
        return 1000.0;

    qreal totalDeviation = 0;
    int count = 0;

    for (const auto &tracePoint : trace) {
        qreal minDistance = 1000.0;
        for (const auto &idealPoint : idealPath) {
            qreal dist = calculateDistance(tracePoint.position, idealPoint);
            if (dist < minDistance)
                minDistance = dist;
        }
        totalDeviation += minDistance;
        count++;
    }

    return (count > 0) ? totalDeviation / count : 1000.0;
}

void TracingEngine::initializeLetterTemplates()
{
    // Initialize letter templates with ideal paths
    // These are simplified paths - in production, these would be more detailed

    // Letter 'a'
    LetterTemplate a;
    a.letter = "a";
    a.idealPath = {
        QPointF(50, 30), QPointF(50, 80),  // vertical line
        QPointF(50, 80), QPointF(80, 80),  // horizontal line
        QPointF(80, 80), QPointF(80, 30)   // vertical line
    };
    a.tolerance = 30.0;
    m_letterTemplates.append(a);

    // Letter 'b'
    LetterTemplate b;
    b.letter = "b";
    b.idealPath = {
        QPointF(30, 20), QPointF(30, 90),  // vertical line
        QPointF(30, 50), QPointF(70, 50),  // horizontal line
        QPointF(70, 50), QPointF(70, 90),  // vertical line
        QPointF(70, 90), QPointF(30, 90)   // horizontal line
    };
    b.tolerance = 30.0;
    m_letterTemplates.append(b);

    // Letter 'c'
    LetterTemplate c;
    c.letter = "c";
    c.idealPath = {
        QPointF(70, 30), QPointF(30, 30),  // top horizontal
        QPointF(30, 30), QPointF(30, 80),  // left vertical
        QPointF(30, 80), QPointF(70, 80)   // bottom horizontal
    };
    c.tolerance = 30.0;
    m_letterTemplates.append(c);

    // Letter 'd'
    LetterTemplate d;
    d.letter = "d";
    d.idealPath = {
        QPointF(70, 20), QPointF(70, 90),  // vertical line
        QPointF(70, 50), QPointF(30, 50),  // horizontal line
        QPointF(30, 50), QPointF(30, 90),  // vertical line
        QPointF(30, 90), QPointF(70, 90)   // horizontal line
    };
    d.tolerance = 30.0;
    m_letterTemplates.append(d);

    // Add more letters as needed...
}

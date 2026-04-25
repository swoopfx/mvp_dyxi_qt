#ifndef TRACINGENGINE_H
#define TRACINGENGINE_H

#include <QObject>
#include <QPointF>
#include <QVector>
#include <QString>

struct TracePoint {
    QPointF position;
    qreal pressure;
    qint64 timestamp;
    qreal speed;
};

struct LetterTemplate {
    QString letter;
    QVector<QPointF> idealPath;
    qreal tolerance;
};

class TracingEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isTracing READ isTracing WRITE setIsTracing NOTIFY isTracingChanged)
    Q_PROPERTY(QString currentLetter READ currentLetter WRITE setCurrentLetter NOTIFY currentLetterChanged)
    Q_PROPERTY(int traceProgress READ traceProgress NOTIFY traceProgressChanged)

public:
    explicit TracingEngine(QObject *parent = nullptr);

    bool isTracing() const;
    void setIsTracing(bool tracing);

    QString currentLetter() const;
    void setCurrentLetter(const QString &letter);

    int traceProgress() const;

    Q_INVOKABLE void addTracePoint(qreal x, qreal y, qreal pressure);
    Q_INVOKABLE void resetTrace();
    Q_INVOKABLE bool validateTrace();
    Q_INVOKABLE QVector<QPointF> getIdealPath(const QString &letter);
    Q_INVOKABLE QVector<QPointF> getCurrentTrace() const;

signals:
    void isTracingChanged();
    void currentLetterChanged();
    void traceProgressChanged();
    void traceValid();
    void traceInvalid();
    void tracePointAdded(qreal x, qreal y);

private:
    bool m_isTracing;
    QString m_currentLetter;
    QVector<TracePoint> m_currentTrace;
    QVector<LetterTemplate> m_letterTemplates;

    void initializeLetterTemplates();
    qreal calculateDeviation(const QVector<TracePoint> &trace, const QVector<QPointF> &idealPath);
    qreal calculateDistance(const QPointF &p1, const QPointF &p2);
    qreal calculateSpeed(const TracePoint &p1, const TracePoint &p2);
};

#endif // TRACINGENGINE_H

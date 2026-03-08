#ifndef TIMER_H
#define TIMER_H

#include <QObject>
#include <QTimer>
#include <QList>
#include <QMap>
#include <QVariant>
#include <QDateTime>
#include <QElapsedTimer>


class Timer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QMap<QString, QVariant>> eventLog READ eventLog NOTIFY eventLogChanged)
public:
    explicit Timer(QObject *parent = nullptr);

    Q_INVOKABLE void startTimer();
    Q_INVOKABLE void stopTimer();
    Q_INVOKABLE void captureTimer(const QString &eventName);





signals:

    /**
     * @brief used to emit a signal to start the timer
     *
     */
    void start();
    void stop();
    void capture(const QString &eventName);
    void eventLogChanged();

public slots:
    void startTime();
    void stopTime();
    void recordEvent(const QString &eventName);



private:
    QTimer *m_timer;
    QElapsedTimer m_elapsedTimer;
    QList<QMap<QString, QVariant>> m_eventlog;
    QList<QMap<QString, QVariant>> eventLog(){return m_eventlog;}
};

#endif // TIMER_H

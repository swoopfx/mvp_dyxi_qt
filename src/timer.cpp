#include "timer.h"

Timer::Timer(QObject *parent)
    : QObject{parent}
{
    m_timer = new QTimer(this);
    connect(this, &Timer::start, this, &Timer::startTime);
    connect(this, &Timer::stop, this, &Timer::stopTime);
    // connect(this, &Timer::capture, this, &Timer::recordEvent);
}

void Timer::startTimer()
{
    emit start();
}

void Timer::stopTimer()
{
    emit stop();
}

void Timer::captureTimer(const QString &eventName)
{
    emit capture(eventName);
}

void Timer::recordEvent(const QString &eventName)
{
    if(m_elapsedTimer.isValid()){
        QMap<QString, QVariant> event;
        event["name"]= eventName;
        QVariant v = QVariant::fromValue(m_elapsedTimer.elapsed());
        event["time"] = v ;
        m_eventlog.append(event);
    }else{
        m_elapsedTimer.start();
        recordEvent(eventName);
    }
    emit eventLogChanged();

}

void Timer::startTime()
{
    m_timer->start();
    m_elapsedTimer.start();
    // emit start();
}

void Timer::stopTime()
{
    m_timer->stop();
    delete m_timer;
    m_timer = nullptr;
    // emit stop();
}



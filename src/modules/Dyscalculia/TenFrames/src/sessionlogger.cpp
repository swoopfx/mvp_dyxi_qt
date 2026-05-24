#include "sessionlogger.h"
#include <QDebug>

SessionLogger::SessionLogger(QObject *parent)
    : QObject(parent), m_sessionStartTime(QDateTime::currentDateTime()), m_lastEventTime(m_sessionStartTime)
{
}

void SessionLogger::logEvent(const QString &eventType, const QVariantMap &data)
{
    QJsonObject event;
    event["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    event["event_type"] = eventType;
    event["relative_time_ms"] = m_lastEventTime.msecsTo(QDateTime::currentDateTime());
    
    QJsonObject dataObj;
    for (auto it = data.begin(); it != data.end(); ++it) {
        dataObj[it.key()] = QJsonValue::fromVariant(it.value());
    }
    event["data"] = dataObj;
    
    m_events.append(event);
    m_lastEventTime = QDateTime::currentDateTime();
}

void SessionLogger::onQuestionAsked(int value, QDateTime time)
{
    QVariantMap data;
    data["question_value"] = value;
    data["asked_at"] = time.toString(Qt::ISODate);
    logEvent("question_asked", data);
}

void SessionLogger::onAnswerSubmitted(bool success, int value, QDateTime time)
{
    QVariantMap data;
    data["success"] = success;
    data["placed_value"] = value;
    data["answered_at"] = time.toString(Qt::ISODate);
    logEvent("answer_submitted", data);
}

void SessionLogger::exportToJson(const QString &filePath)
{
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly)) {
        QJsonDocument doc(m_events);
        file.write(doc.toJson());
        file.close();
    }
}

QString SessionLogger::getJsonData() const
{
    QJsonDocument doc(m_events);
    return doc.toJson(QJsonDocument::Indented);
}

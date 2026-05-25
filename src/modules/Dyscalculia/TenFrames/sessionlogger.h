#ifndef SESSIONLOGGER_H
#define SESSIONLOGGER_H

#include <QObject>
#include <QVariantList>
#include <QDateTime>
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QQmlEngine>

class SessionLogger : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit SessionLogger(QObject *parent = nullptr);

    Q_INVOKABLE void logEvent(const QString &eventType, const QVariantMap &data);
    Q_INVOKABLE void exportToJson(const QString &filePath);
    Q_INVOKABLE QString getJsonData() const;

public slots:
    void onQuestionAsked(int value, QDateTime time);
    void onAnswerSubmitted(bool success, int value, QDateTime time);

private:
    QJsonArray m_events;
    QDateTime m_sessionStartTime;
    QDateTime m_lastEventTime;
};

#endif // SESSIONLOGGER_H

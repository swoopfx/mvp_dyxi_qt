#ifndef ACTIVITYLOGGER_H
#define ACTIVITYLOGGER_H

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QFile>
#include <QDateTime>
#include <QQmlEngine>

class ActivityLogger : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit ActivityLogger(const QString& logFilePath, QObject *parent = nullptr)
        : QObject(parent), m_logFilePath(logFilePath) {
        loadLogsFromFile();
    }

    void logEvent(const QString& eventType, const QJsonObject& details) {
        QJsonObject entry;
        entry["timestamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
        entry["event"] = eventType;
        entry["details"] = details;
        m_logEntries.append(entry);
        saveLogsToFile();
        emit newLogEntry(entry);
    }

    Q_INVOKABLE QString getLogsAsJsonString() const {
        return QJsonDocument(m_logEntries).toJson(QJsonDocument::Indented);
    }

    Q_INVOKABLE void clearLogs() {
        m_logEntries = QJsonArray();
        saveLogsToFile();
    }

signals:
    void newLogEntry(const QJsonObject& entry);

private:
    QString m_logFilePath;
    QJsonArray m_logEntries;

    void saveLogsToFile() const {
        QFile file(m_logFilePath);
        if (file.open(QIODevice::WriteOnly)) {
            file.write(QJsonDocument(m_logEntries).toJson());
            file.close();
        }
    }

    void loadLogsFromFile() {
        QFile file(m_logFilePath);
        if (file.open(QIODevice::ReadOnly)) {
            m_logEntries = QJsonDocument::fromJson(file.readAll()).array();
            file.close();
        }
    }
};

#endif // ACTIVITYLOGGER_H

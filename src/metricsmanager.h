#ifndef METRICSMANAGER_H
#define METRICSMANAGER_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QString>
#include <QMap>

struct SessionData {
    QString sessionId;
    QString timestamp;
    QString difficulty;
    QJsonArray words;
    QJsonArray letterMetrics;
    int totalScore;
    int accuracy;
};

class MetricsManager : public QObject
{
    Q_OBJECT

public:
    explicit MetricsManager(QObject *parent = nullptr);

    Q_INVOKABLE void startSession(const QString &difficulty);
    Q_INVOKABLE void endSession();
    Q_INVOKABLE void recordLetterMetrics(const QString &letter, const QJsonObject &metrics);
    Q_INVOKABLE void recordWordCompletion(const QString &word, bool success, int timeMs);
    Q_INVOKABLE QJsonObject getSessionData();
    Q_INVOKABLE bool exportSessionToFile(const QString &filePath);
    Q_INVOKABLE bool exportSessionToCloud(const QString &cloudUrl);
    Q_INVOKABLE QJsonArray getAllSessions();

signals:
    void sessionStarted();
    void sessionEnded();
    void metricsRecorded();
    void exportSuccess();
    void exportFailed(const QString &error);

private:
    SessionData m_currentSession;
    QJsonArray m_allSessions;
    bool m_sessionActive;

    QString generateSessionId();
    QString getCurrentTimestamp();
    QJsonObject sessionToJson(const SessionData &session);
};

#endif // METRICSMANAGER_H

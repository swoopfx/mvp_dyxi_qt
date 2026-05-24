#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QDateTime>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QFile>
#include <QDebug>
#include <QQmlEngine>

class GameEngine : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int score READ score NOTIFY scoreChanged)
    Q_PROPERTY(double accuracy READ accuracy NOTIFY metricsChanged)
    Q_PROPERTY(double avgSpeed READ avgSpeed NOTIFY metricsChanged)
    Q_PROPERTY(int failCount READ failCount NOTIFY metricsChanged)
    Q_PROPERTY(int correctCount READ correctCount NOTIFY metricsChanged)
    Q_PROPERTY(double concentrationScore READ concentrationScore NOTIFY metricsChanged)

public:
    explicit GameEngine(QObject *parent = nullptr);

    int score() const { return m_score; }
    int failCount() const { return m_failCount; }
    int correctCount() const { return m_correctCount; }
    double accuracy() const;
    double avgSpeed() const;
    double concentrationScore() const;

    Q_INVOKABLE void startGame(const QString &difficulty);
    Q_INVOKABLE void logEvent(const QString &eventType, const QJsonObject &details);
    Q_INVOKABLE void saveSessionData();
    Q_INVOKABLE void recordMatch(bool correct, int timeMs);

signals:
    void scoreChanged();
    void metricsChanged();
    void gameFinished(const QJsonObject &summary);

private:
    int m_score = 0;
    int m_correctCount = 0;
    int m_failCount = 0;
    QList<int> m_solveTimes;
    QJsonArray m_activityLog;
    QDateTime m_sessionStart;
    QString m_currentDifficulty;
    QList<qint64> m_timestamps;

    void updateMetrics();
};

#endif // GAMEENGINE_H

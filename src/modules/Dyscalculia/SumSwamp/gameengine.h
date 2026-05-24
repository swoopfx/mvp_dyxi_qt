#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QVariantList>
#include <QDateTime>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QFile>
#include <QElapsedTimer>

class GameEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)
    Q_PROPERTY(double averageSpeed READ averageSpeed NOTIFY metricsUpdated)
    Q_PROPERTY(double accuracy READ accuracy NOTIFY metricsUpdated)

public:
    explicit GameEngine(QObject *parent = nullptr);

    Q_INVOKABLE void startSession();
    Q_INVOKABLE void processAnswer(int num1, QString op, int num2, int userAnswer);
    Q_INVOKABLE void saveLog();
    Q_INVOKABLE QVariantMap getMetrics();

    QString difficulty() const { return m_difficulty; }
    void setDifficulty(const QString &diff) { 
        if (m_difficulty != diff) {
            m_difficulty = diff;
            emit difficultyChanged();
        }
    }

    double averageSpeed() const;
    double accuracy() const;

signals:
    void difficultyChanged();
    void metricsUpdated();
    void logSaved(QString path);

private:
    QString m_difficulty = "Frog";
    QElapsedTimer m_turnTimer;
    QJsonArray m_events;
    int m_correctCount = 0;
    int m_totalCount = 0;
    double m_totalTime = 0.0;
    QJsonObject m_errorTypes;
};

#endif // GAMEENGINE_H

#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QVariantList>
#include <QDateTime>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include <cmath>

class GameEngine : public QObject {
    Q_OBJECT
    Q_PROPERTY(int target READ target NOTIFY targetChanged)
    Q_PROPERTY(QVariantList scoringDice READ scoringDice NOTIFY scoringDiceChanged)
    Q_PROPERTY(QString difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)

public:
    explicit GameEngine(QObject *parent = nullptr);

    int target() const { return m_target; }
    QVariantList scoringDice() const { return m_scoringDice; }
    QString difficulty() const { return m_difficulty; }

    void setDifficulty(const QString &difficulty);

    Q_INVOKABLE void rollDice();
    Q_INVOKABLE bool validateEquation(const QString &equation);
    Q_INVOKABLE QJsonObject getMetrics();
    Q_INVOKABLE bool isFocusSprintActive() const { return m_focusSprintActive; }
    Q_INVOKABLE int focusSprintProgress() const { return m_focusSprintProgress; }
    Q_INVOKABLE void startFocusSprint();

signals:
    void targetChanged();
    void scoringDiceChanged();
    void difficultyChanged();
    void eventLogged(QJsonObject event);

private:
    void logEvent(const QString &type, const QJsonObject &data);
    double calculateConcentration();
    
    int m_target;
    QVariantList m_scoringDice;
    QString m_difficulty;
    
    // Metrics
    int m_correctCount = 0;
    int m_totalAttempts = 0;
    QList<double> m_responseTimes;
    QDateTime m_lastRollTime;
    QDateTime m_sessionStartTime;
    
    struct ErrorLog {
        QString equation;
        QString type;
    };
    QList<ErrorLog> m_errors;
    bool m_focusSprintActive = false;
    int m_focusSprintProgress = 0;
};

#endif // GAMEENGINE_H

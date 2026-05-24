#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QVariantList>
#include <QDateTime>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QFile>
#include <QDebug>

class GameEngine : public QObject {
    Q_OBJECT
    Q_PROPERTY(int targetSum READ targetSum WRITE setTargetSum NOTIFY targetSumChanged)
    Q_PROPERTY(QVariantList metrics READ metrics NOTIFY metricsChanged)

public:
    explicit GameEngine(QObject *parent = nullptr);

    int targetSum() const { return m_targetSum; }
    void setTargetSum(int sum) { if (m_targetSum != sum) { m_targetSum = sum; emit targetSumChanged(); } }

    QVariantList metrics() const;

    Q_INVOKABLE void startGame(int difficulty);
    Q_INVOKABLE bool attemptMove(int cardValue1, int cardValue2);
    Q_INVOKABLE void logEvent(const QString &type, const QJsonObject &data);
    Q_INVOKABLE void exportMetrics();

signals:
    void targetSumChanged();
    void metricsChanged();
    void moveResult(bool success, const QString &message);

private:
    int m_targetSum = 100;
    int m_correctMoves = 0;
    int m_failedMoves = 0;
    QDateTime m_startTime;
    QJsonArray m_eventLog;

    void updateMetrics();
};

#endif // GAMEENGINE_H

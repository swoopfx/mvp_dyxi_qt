#ifndef TELEMETRYBACKEND_H
#define TELEMETRYBACKEND_H

#include <QObject>
#include <QVariantList>
#include <QDateTime>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QStringList>
#include <QSoundEffect>
#include <QUrl>
#include <QQmlEngine>

class TelemetryBackend : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int totalTries READ totalTries NOTIFY telemetryUpdated)
    Q_PROPERTY(int totalCorrect READ totalCorrect NOTIFY telemetryUpdated)
    Q_PROPERTY(int totalFailed READ totalFailed NOTIFY telemetryUpdated)
    Q_PROPERTY(double creativeIndex READ creativeIndex NOTIFY telemetryUpdated)
    Q_PROPERTY(double problemSolvingIndex READ problemSolvingIndex NOTIFY telemetryUpdated)
    Q_PROPERTY(double speedIndex READ speedIndex NOTIFY telemetryUpdated)
    Q_PROPERTY(double averageCorrectTime READ averageCorrectTime NOTIFY telemetryUpdated)
    Q_PROPERTY(double averageFailedTime READ averageFailedTime NOTIFY telemetryUpdated)

public:
    explicit TelemetryBackend(QObject *parent = nullptr);

    int totalTries() const { return m_totalTries; }
    int totalCorrect() const { return m_totalCorrect; }
    int totalFailed() const { return m_totalFailed; }
    double creativeIndex() const { return m_creativeIndex; }
    double problemSolvingIndex() const { return m_problemSolvingIndex; }
    double speedIndex() const { return m_speedIndex; }
    double averageCorrectTime() const { return m_averageCorrectTime; }
    double averageFailedTime() const { return m_averageFailedTime; }

    Q_INVOKABLE void logMatch(const QString &shapeName, const QString &shapeType, bool success, double durationMs, double selectToMatchMs);
    Q_INVOKABLE void logPress(double durationMs, const QString &direction, double distance);
    Q_INVOKABLE QString getTelemetryJson() const;
    Q_INVOKABLE void resetTelemetry();
    Q_INVOKABLE void playSelect();
    Q_INVOKABLE void playCorrect();
    Q_INVOKABLE void playFail();

signals:
    void telemetryUpdated();
    void matchSuccessToast(const QString &shapeName);
    void matchFailToast(const QString &shapeName);

private:
    void recomputeIndices();

    int m_totalTries;
    int m_totalCorrect;
    int m_totalFailed;
    double m_creativeIndex;
    double m_problemSolvingIndex;
    double m_speedIndex;
    double m_averageCorrectTime;
    double m_averageFailedTime;

    QVariantList m_matchDurations;
    QVariantList m_failedDurations;
    QJsonArray m_pressDownEvents;
    QJsonArray m_matchEvents;

    QSoundEffect m_soundSelect;
    QSoundEffect m_soundCorrect;
    QSoundEffect m_soundFail;
};

#endif // TELEMETRYBACKEND_H

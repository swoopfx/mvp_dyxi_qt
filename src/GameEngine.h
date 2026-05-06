#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QString>
#include <QVariantMap>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QFile>
#include <QDateTime>
#include <QTextToSpeech>
#include <QElapsedTimer>
#include <QSet>
#include <QQmlEngine>

class GameEngine : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString metricsJson READ metricsJson NOTIFY metricsChanged)

public:
    explicit GameEngine(QObject *parent = nullptr);
    ~GameEngine();

    QString metricsJson() const;

    Q_INVOKABLE void logActivity(const QString &event, const QVariantMap &details);
    Q_INVOKABLE void speak(const QString &text);
    Q_INVOKABLE void exportData();

signals:
    void metricsChanged();

private:
    void updateMetrics();
    void saveLogs();

    QJsonArray m_activityLogs;
    QTextToSpeech *m_speech;
    QElapsedTimer m_sessionTimer;
    
    // Telemetrics
    int m_correctActions = 0;
    int m_totalActions = 0;
    QSet<QString> m_uniqueWords;
    int m_wordsCompleted = 0;
    double m_accuracy = 0.0;
    double m_fluencyIndex = 0.0;
    double m_pmi = 0.0;
};

#endif // GAMEENGINE_H

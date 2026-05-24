#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QString>
#include <QVariantMap>
#include <QAudioInput>
#include <QFile>
#include <QTextToSpeech>
#include <QTimer>

class GameEngine : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString currentAnimal READ currentAnimal NOTIFY currentAnimalChanged)
    Q_PROPERTY(bool isTalking READ isTalking NOTIFY isTalkingChanged)

public:
    explicit GameEngine(QObject *parent = nullptr);
    
    QString currentAnimal() const { return m_currentAnimal; }
    bool isTalking() const { return m_isTalking; }

    Q_INVOKABLE void startIntro();
    Q_INVOKABLE void replayIntro();
    Q_INVOKABLE void startWordExercise(const QString &word);
    Q_INVOKABLE void recordResponse(const QString &word, int attempt);
    Q_INVOKABLE void submitMetrics();

signals:
    void currentAnimalChanged();
    void isTalkingChanged();
    void wordReadComplete();
    void recordingComplete(const QString &filePath);
    void apiResponse(bool success, const QString &message);

private slots:
    void handleSpeechStateChanged(QTextToSpeech::State state);

private:
    QString m_currentAnimal;
    bool m_isTalking = false;
    QTextToSpeech *m_tts;
    QString m_sessionId;
    QList<QVariantMap> m_metrics;
    
    void selectRandomAnimal();
    void logEvent(const QString &type, const QVariantMap &data);
    double calculateFluency();
    double calculateAccuracy();
};

#endif // GAMEENGINE_H

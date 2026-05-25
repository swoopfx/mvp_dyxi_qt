#ifndef GAMEENGINEW_H
#define GAMEENGINEW_H

#include <QObject>
#include <QStringList>
#include <QVariantMap>
#include <QJsonArray>
#include <QJsonObject>
#include <QTimer>
#include <QQmlEngine>

class GameEnginew : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString currentWord READ currentWord NOTIFY currentWordChanged)
    Q_PROPERTY(QString currentImage READ currentImage NOTIFY currentImageChanged)
    Q_PROPERTY(bool isRecording READ isRecording NOTIFY isRecordingChanged)

public:
    explicit GameEnginew(QObject *parent = nullptr);

    QString currentWord() const { return m_currentWord; }
    QString currentImage() const { return m_currentImage; }
    bool isRecording() const { return m_isRecording; }

    Q_INVOKABLE void nextWord();
    Q_INVOKABLE void startRecording();
    Q_INVOKABLE void stopRecording();
    Q_INVOKABLE void submitMetrics(const QVariantMap &metrics);
    Q_INVOKABLE void logEvent(const QString &event, const QVariantMap &data = QVariantMap());

signals:
    void currentWordChanged();
    void currentImageChanged();
    void isRecordingChanged();
    void recordingFinished(const QString &fileName);
    void apiResponseReceived(bool success, const QString &message);

private:
    void loadWordDatabase();
    void calculateAdvancedMetrics(QJsonObject &metricsObj);
    void simulateApiCall(const QJsonObject &payload, const QString &audioPath);

    QStringList m_wordDatabase;
    QString m_currentWord;
    QString m_currentImage;
    bool m_isRecording;
    QJsonArray m_eventLog;
    QString m_sessionId;
};

#endif // GAMEENGINEW_H

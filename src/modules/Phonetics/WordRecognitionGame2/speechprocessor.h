#ifndef SPEECHPROCESSOR_H
#define SPEECHPROCESSOR_H

#include <QObject>
#include <QString>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QAudioSource>
#include <QFile>
#include <QQmlEngine>

/**
 * @brief SpeechProcessor translates recorded audio via local-first Whisper.cpp,
 * computes kid-centered metrics, logs activity events, and posts JSON data to an endpoint.
 */
class SpeechProcessor : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    // QML_NAMED_ELEMENT()
    Q_PROPERTY(QString sessionId READ sessionId WRITE setSessionId NOTIFY sessionIdChanged)

public:
    explicit SpeechProcessor(QObject *parent = nullptr);
    ~SpeechProcessor();

    QString sessionId() const { return m_sessionId; }
    void setSessionId(const QString &sid) {
        if (m_sessionId != sid) {
            m_sessionId = sid;
            emit sessionIdChanged();
        }
    }

signals:
    void sessionIdChanged();
    void speechEvaluationCompleted(int accuracy, int fluency, int vocabulary, int memory, int consistency, double speechRate, QString pronunciationGrade, QString logJson);
    void recordingFailed(QString errorDetail);
    void ttsPlayFinished();

public slots:
    // Controls
    void startRecording(const QString &fileName);
    void stopAndAnalyze(const QString &expectedWord, qint64 timeTakenMs);
    void speak(const QString &text);
    
    // Reset and export sessions
    void resetSession();
    Q_INVOKABLE QString exportSessionSummaryJson();

private slots:
    void handleUploadFinished();
    void handleUploadError(QNetworkReply::NetworkError code);

private:
    QString m_sessionId;
    QAudioSource *m_audioSource;
    QFile m_tempFile;
    QString m_currentFileName;
    QNetworkAccessManager *m_networkManager;

    // Computational Metrics Engines (C++ heavy logic helpers)
    int calculateSpellAccuracy(const QString &expected, const QString &spoken);
    int computeFluencyIndex(qint64 timeTakenMs, int accuracy);
    int computeVocabularyScore(const QString &session, const QString &word);
    int computeMemoryCapacity(const QString &word, qint64 currentTimingMs);
    int computePhonicConsistency(const QString &word, int currentAccuracy);
    double computeSpeechRate(const QString &word, qint64 timeTakenMs);
    QString computePronunciationGrade(int accuracy, int difficulty);

    // Event log storage
    QJsonArray m_eventHistory;
    QJsonArray m_activitiesArray;
};

#endif // SPEECHPROCESSOR_H

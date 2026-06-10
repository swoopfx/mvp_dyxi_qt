// #ifndef SPEECHENGINE_H
// #define SPEECHENGINE_H

// #include <QObject>
// #include <QString>
// #include <QVector>
// #include <QJsonObject>
// #include <QJsonDocument>
// #include <QNetworkAccessManager>
// #include <QNetworkReply>
// #include <QNetworkRequest>
// #include <QFile>

// // Forward declaration of Whisper structures to avoid global exposure
// struct whisper_context;

// class SpeechEngine : public QObject
// {
//     Q_OBJECT
    
//     // Qt properties to interface with QML bindings
//     Q_PROPERTY(int latestFluency READ latestFluency NOTIFY metricsChanged)
//     Q_PROPERTY(int latestAccuracy READ latestAccuracy NOTIFY metricsChanged)
//     Q_PROPERTY(int latestVocabulary READ latestVocabulary NOTIFY metricsChanged)
//     Q_PROPERTY(int latestMemory READ latestMemory NOTIFY metricsChanged)
//     Q_PROPERTY(double progressIndex READ progressIndex NOTIFY metricsChanged)
//     Q_PROPERTY(QString transcription READ transcription NOTIFY transcriptionChanged)
//     Q_PROPERTY(bool isWhisperLoaded READ isWhisperLoaded NOTIFY whisperStatusChanged)

// public:
//     explicit SpeechEngine(QObject *parent = nullptr);
//     ~SpeechEngine() override;

//     int latestFluency() const { return m_fluency; }
//     int latestAccuracy() const { return m_accuracy; }
//     int latestVocabulary() const { return m_vocabulary; }
//     int latestMemory() const { return m_memory; }
//     double progressIndex() const { return m_progressIndex; }
//     QString transcription() const { return m_transcription; }
//     bool isWhisperLoaded() const { return m_whisperCtx != nullptr; }

// signals:
//     void metricsChanged();
//     void transcriptionChanged();
//     void whisperStatusChanged();
//     void audioProcessingFinished(const QString &recordId, bool success);
//     void networkErrorOccurred(const QString &errorMessage);

// public slots:
//     // Load local GGML model binary path (e.g., "models/ggml-tiny.en.bin")
//     bool loadWhisperModel(const QString &modelPath);

//     // Audio file ingestion: decodes 16kHz PCM WAV format and transcribes with whisper.cpp
//     void evaluateAcousticMetrics(const QString &targetWord, int trialIndex, int responseDurationMs, const QString &audioFilePath);
    
//     // Upload analytical parameters and scoring structures to pediatric telemetry platform
//     void submitPerformancePayload(const QString &sessionId, const QString &wordSpoken, int trialIndex, int timeTakenMs, const QString &audioFilePath);

//     // Phonetic IPA translation & Speech Synthesis pipelines (Whisper-Phoneme core)
//     QString convertTextToIPA(const QString &text);
//     bool synthesizeIpaToAudio(const QString &ipaSyllables, const QString &outputAudioPath);

//     // C++ Backend Audio Recording & Playback Operations
//     void startVoiceRecording();
//     void stopVoiceRecordingAndAnalyze(const QString &targetWord, int trialIndex);
//     void speakTextOrIpa(const QString &textOrIpa, bool isIpa = true);

// private:
//     // Downsamples or reads WAV file header data to get floating-point mono audio blocks
//     bool readWavFileMono(const QString &filePath, QVector<float> &pcm32);
    
//     // Evaluates the string distance accuracy score
//     int calculateWordDifference(const QString &s1, const QString &s2);

//     int m_fluency;
//     int m_accuracy;
//     int m_vocabulary;
//     int m_memory;
//     double m_progressIndex;
//     QString m_transcription;

//     // Native whisper.cpp configuration pointer
//     struct whisper_context *m_whisperCtx;
//     QNetworkAccessManager *m_networkManager;
    
//     // Qt native audio state trackers
//     QFile *m_recordingFile;
//     QObject *m_audioSource;
// };

// #endif // SPEECHENGINE_H

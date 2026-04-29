#ifndef SPEECHMANAGER_H
#define SPEECHMANAGER_H

#include <QObject>
#include <QAudioRecorder>
#include <QProcess>
#include <QUrl>

class SpeechManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool recording READ recording NOTIFY recordingChanged)
    Q_PROPERTY(QString recognizedText READ recognizedText NOTIFY recognizedTextChanged)

public:
    explicit SpeechManager(QObject *parent = nullptr);
    ~SpeechManager();

    bool recording() const { return m_recording; }
    QString recognizedText() const { return m_recognizedText; }

    Q_INVOKABLE void startRecording();
    Q_INVOKABLE void stopRecording();

signals:
    void recordingChanged();
    void recognizedTextChanged();
    void transcriptionReady(const QString &text);
    void error(const QString &message);

private slots:
    void onStateChanged(QMediaRecorder::State state);
    void onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void onProcessErrorOccurred(QProcess::ProcessError error);

private:
    QAudioRecorder *m_audioRecorder;
    QProcess *m_speechToTextProcess;
    QString m_outputFilePath;
    bool m_recording;
    QString m_recognizedText;

    void setRecording(bool recording);
    void setRecognizedText(const QString &text);
};

#endif // SPEECHMANAGER_H

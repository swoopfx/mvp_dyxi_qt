#include "speechmanager.h"
#include <QStandardPaths>
#include <QDir>
#include <QDateTime>
#include <QDebug>

SpeechManager::SpeechManager(QObject *parent)
    : QObject(parent),
      m_audioRecorder(new QAudioRecorder(this)),
      m_speechToTextProcess(new QProcess(this)),
      m_recording(false)
{
    // Setup audio recorder
    m_audioRecorder->setAudioInput(m_audioRecorder->defaultAudioInput());
    QAudioEncoderSettings audioSettings;
    audioSettings.setCodec("audio/pcm"); // Use PCM for raw audio, suitable for transcription
    audioSettings.setSampleRate(16000); // Common sample rate for speech recognition
    audioSettings.setChannelCount(1); // Mono
    audioSettings.setQuality(QMultimedia::EncodingQuality::HighQuality);
    m_audioRecorder->setEncodingSettings(audioSettings);
    m_audioRecorder->setContainerFormat("wav"); // WAV format

    connect(m_audioRecorder, &QMediaRecorder::stateChanged, this, &SpeechManager::onStateChanged);
    connect(m_audioRecorder, QOverload<QMediaRecorder::Error>::of(&QMediaRecorder::error), this, [this](QMediaRecorder::Error error) {
        emit this->error(QString("Audio Recorder Error: %1").arg(m_audioRecorder->errorString()));
        Q_UNUSED(error);
    });

    // Setup speech-to-text process
    connect(m_speechToTextProcess, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), this, &SpeechManager::onProcessFinished);
    connect(m_speechToTextProcess, &QProcess::errorOccurred, this, &SpeechManager::onProcessErrorOccurred);
}

SpeechManager::~SpeechManager()
{
    // Clean up temporary file if it exists
    if (!m_outputFilePath.isEmpty()) {
        QFile::remove(m_outputFilePath);
    }
}

void SpeechManager::startRecording()
{
    if (m_audioRecorder->state() == QMediaRecorder::StoppedState) {
        // Create a unique temporary file path
        QString tempDir = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
        m_outputFilePath = tempDir + QDir::separator() + QDateTime::currentDateTime().toString("yyyyMMdd_hhmmsszzz") + ".wav";
        m_audioRecorder->setOutputLocation(QUrl::fromLocalFile(m_outputFilePath));
        m_audioRecorder->record();
        setRecording(true);
        setRecognizedText(""); // Clear previous recognition
        qDebug() << "Recording started to:" << m_outputFilePath;
    } else {
        emit error("Audio recorder is not in stopped state.");
    }
}

void SpeechManager::stopRecording()
{
    if (m_audioRecorder->state() == QMediaRecorder::RecordingState) {
        m_audioRecorder->stop();
        setRecording(false);
        qDebug() << "Recording stopped.";
    } else {
        emit error("Audio recorder is not in recording state.");
    }
}

void SpeechManager::onStateChanged(QMediaRecorder::State state)
{
    if (state == QMediaRecorder::StoppedState && !m_outputFilePath.isEmpty() && QFile::exists(m_outputFilePath)) {
        qDebug() << "Audio recording finished. Starting transcription process.";
        // Call manus-speech-to-text tool
        QString program = "manus-speech-to-text";
        QStringList arguments;
        arguments << m_outputFilePath;
        m_speechToTextProcess->start(program, arguments);
        if (!m_speechToTextProcess->waitForStarted()) {
            emit error(QString("Failed to start speech-to-text process: %1").arg(m_speechToTextProcess->errorString()));
            QFile::remove(m_outputFilePath);
            m_outputFilePath.clear();
        }
    }
}

void SpeechManager::onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    if (exitStatus == QProcess::NormalExit && exitCode == 0) {
        QString output = m_speechToTextProcess->readAllStandardOutput();
        QString recognized = output.trimmed();
        setRecognizedText(recognized);
        emit transcriptionReady(recognized);
        qDebug() << "Transcription ready:" << recognized;
    } else {
        QString errorOutput = m_speechToTextProcess->readAllStandardError();
        emit error(QString("Speech-to-text process failed with exit code %1: %2").arg(exitCode).arg(errorOutput));
        setRecognizedText("Error during transcription.");
    }

    // Clean up the temporary audio file
    if (!m_outputFilePath.isEmpty()) {
        QFile::remove(m_outputFilePath);
        m_outputFilePath.clear();
    }
}

void SpeechManager::onProcessErrorOccurred(QProcess::ProcessError error)
{
    emit this->error(QString("Speech-to-text process error: %1").arg(m_speechToTextProcess->errorString()));
    Q_UNUSED(error);
    // Clean up the temporary audio file in case of process error
    if (!m_outputFilePath.isEmpty()) {
        QFile::remove(m_outputFilePath);
        m_outputFilePath.clear();
    }
}

void SpeechManager::setRecording(bool recording)
{
    if (m_recording == recording)
        return;

    m_recording = recording;
    emit recordingChanged();
}

void SpeechManager::setRecognizedText(const QString &text)
{
    if (m_recognizedText == text)
        return;

    m_recognizedText = text;
    emit recognizedTextChanged();
}

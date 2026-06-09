#ifndef WHISPERWORKER_H
#define WHISPERWORKER_H

#include <QObject>
#include <QQmlEngine>
#include <QString>
#include "whisper.h"

class whisperworker : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit whisperworker(QObject *parent = nullptr);

    public slots:
    // Slot to trigger transcription. Expects 16kHz mono PCM float audio data.
    void processAudio(const QString &modelPath, const QVector<float> &audioData);


signals:
    void transcriptionFinished(const QString &text);
    void statusMessage(const QString &message);
    void errorOccurred(const QString &error);


private :
    whisper_context *m_ctx = nullptr;
};

#endif // WHISPERWORKER_H

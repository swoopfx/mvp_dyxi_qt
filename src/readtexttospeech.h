#ifndef READTEXTTOSPEECH_H
#define READTEXTTOSPEECH_H

#include <QObject>
#include <QQmlEngine>
#include <QTextToSpeech>

class ReadTextToSpeech : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit ReadTextToSpeech(QObject *parent = nullptr);

signals:

private:
    QTextToSpeech *tts;
};

#endif // READTEXTTOSPEECH_H

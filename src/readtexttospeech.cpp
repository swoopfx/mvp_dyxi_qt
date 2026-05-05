#include "readtexttospeech.h"

ReadTextToSpeech::ReadTextToSpeech(QObject *parent)
    : QObject{parent}
{
    tts = new QTextToSpeech(this);
}

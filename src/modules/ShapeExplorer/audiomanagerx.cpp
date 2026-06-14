#include "audiomanagerx.h"

AudioManagerx::AudioManagerx(QObject *parent)
    : QObject(parent)
{
    m_success.setSource(
        QUrl("qrc:/Recognition/ShapeExplorer/assets/success.wav"));

    m_failure.setSource(
        QUrl("qrc:/Recognition/ShapeExplorer/assets/failure.wav"));

    m_rabbit.setSource(
        QUrl("qrc:/Recognition/ShapeExplorer/assets/rabbit_appear.wav"));

    m_rabbit.setVolume(0.15f);
}

void AudioManagerx::playSuccess()
{
    m_success.play();
}

void AudioManagerx::playFailure()
{
    m_failure.play();
}

void AudioManagerx::playRabbit()
{
    m_rabbit.play();
}
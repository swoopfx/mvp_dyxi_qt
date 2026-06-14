#include "../recogaudiomanager.h"

RecogAudioManager::RecogAudioManager(QObject *parent)
    : QObject{parent}
{
    m_success.setSource(
        QUrl("qrc:/Recognition/ShapeExplorer/assets/success.wav"));

    m_failure.setSource(
        QUrl("qrc:/Recognition/ShapeExplorer/assets/failure.wav"));

    m_rabbit.setSource(
        QUrl("qrc:/Recognition/ShapeExplorer/assets/rabbit_appear.wav"));

    m_rabbit.setVolume(0.15f);
}

void RecogAudioManager::playSuccess()
{
 m_success.play();
}

void RecogAudioManager::playFailure()
{
m_failure.play();
}

void RecogAudioManager::playRabbit()
{
    m_rabbit.play();
}

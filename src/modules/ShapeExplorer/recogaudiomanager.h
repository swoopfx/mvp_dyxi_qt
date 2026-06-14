#ifndef RECOGAUDIOMANAGER_H
#define RECOGAUDIOMANAGER_H

#include <QObject>
#include <QQmlEngine>
#include <QSoundEffect>

class RecogAudioManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit RecogAudioManager(QObject *parent = nullptr);
    Q_INVOKABLE void playSuccess();
    Q_INVOKABLE void playFailure();
    Q_INVOKABLE void playRabbit();

private:
    QSoundEffect m_success;
    QSoundEffect m_failure;
    QSoundEffect m_rabbit;

};
#endif // RECOGAUDIOMANAGER_H

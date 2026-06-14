#ifndef AUDIOMANAGERX_H
#define AUDIOMANAGERX_H

#include <QObject>
#include <QQmlEngine>
#include <QSoundEffect>

class AudioManagerx : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_NAMED_ELEMENT(AudioManagerx)
public:
    explicit AudioManagerx(QObject *parent = nullptr);

    Q_INVOKABLE void playSuccess();
    Q_INVOKABLE void playFailure();
    Q_INVOKABLE void playRabbit();

private:
    QSoundEffect m_success;
    QSoundEffect m_failure;
    QSoundEffect m_rabbit;
};

#endif // AUDIOMANAGERX_H

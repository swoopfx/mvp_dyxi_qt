#ifndef AUDIOENGINE_H
#define AUDIOENGINE_H

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QString>
#include <QMap>

class AudioEngine : public QObject
{
    Q_OBJECT

public:
    explicit AudioEngine(QObject *parent = nullptr);
    ~AudioEngine();

    Q_INVOKABLE void playClickSound();
    Q_INVOKABLE void playErrorSound();
    Q_INVOKABLE void playSuccessSound();
    Q_INVOKABLE void playLetterAudio(const QString &letter);
    Q_INVOKABLE void playWordAudio(const QString &word);
    Q_INVOKABLE void stopAudio();
    Q_INVOKABLE void setVolume(int volume);

signals:
    void audioFinished();
    void audioError(const QString &error);

private:
    QMediaPlayer *m_player;
    QAudioOutput *m_audioOutput;
    QMap<QString, QString> m_audioCache;

    void initializeAudioCache();
    QString getAudioPath(const QString &identifier);
};

#endif // AUDIOENGINE_H

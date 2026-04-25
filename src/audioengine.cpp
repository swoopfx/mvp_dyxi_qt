#include "audioengine.h"
#include <QDebug>

AudioEngine::AudioEngine(QObject *parent)
    : QObject(parent)
{
    m_player = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);
    m_player->setAudioOutput(m_audioOutput);

    connect(m_player, &QMediaPlayer::playbackStateChanged, this, [this]() {
        if (m_player->playbackState() == QMediaPlayer::StoppedState) {
            emit audioFinished();
        }
    });

    connect(m_player, QOverload<QMediaPlayer::Error>::of(&QMediaPlayer::error), this, [this]() {
        emit audioError(m_player->errorString());
    });

    initializeAudioCache();
}

AudioEngine::~AudioEngine()
{
}

void AudioEngine::playClickSound()
{
    QString path = getAudioPath("click");
    if (!path.isEmpty()) {
        m_player->setSource(QUrl::fromLocalFile(path));
        m_player->play();
    }
}

void AudioEngine::playErrorSound()
{
    QString path = getAudioPath("error");
    if (!path.isEmpty()) {
        m_player->setSource(QUrl::fromLocalFile(path));
        m_player->play();
    }
}

void AudioEngine::playSuccessSound()
{
    QString path = getAudioPath("success");
    if (!path.isEmpty()) {
        m_player->setSource(QUrl::fromLocalFile(path));
        m_player->play();
    }
}

void AudioEngine::playLetterAudio(const QString &letter)
{
    QString path = getAudioPath("letter_" + letter);
    if (!path.isEmpty()) {
        m_player->setSource(QUrl::fromLocalFile(path));
        m_player->play();
    }
}

void AudioEngine::playWordAudio(const QString &word)
{
    QString path = getAudioPath("word_" + word);
    if (!path.isEmpty()) {
        m_player->setSource(QUrl::fromLocalFile(path));
        m_player->play();
    }
}

void AudioEngine::stopAudio()
{
    m_player->stop();
}

void AudioEngine::setVolume(int volume)
{
    m_audioOutput->setVolume(volume / 100.0);
}

void AudioEngine::initializeAudioCache()
{
    // Map identifiers to audio file paths
    // Audio files are embedded in resources
    m_audioCache["click"] = "qrc:/assets/audio/click.wav";
    m_audioCache["error"] = "qrc:/assets/audio/error.wav";
    m_audioCache["success"] = "qrc:/assets/audio/success.wav";

    // Letter audio files
    QStringList letters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
                          "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
                          "u", "v", "w", "x", "y", "z"};

    for (const auto &letter : letters) {
        m_audioCache["letter_" + letter] = "qrc:/assets/audio/letter_" + letter + ".wav";
    }

    // Common words for 3-4 letters
    QStringList words = {"cat", "dog", "bat", "rat", "hat", "mat", "sat", "pat",
                        "book", "look", "cook", "took", "hook", "good", "food", "wood"};

    for (const auto &word : words) {
        m_audioCache["word_" + word] = "qrc:/assets/audio/word_" + word + ".wav";
    }
}

QString AudioEngine::getAudioPath(const QString &identifier)
{
    if (m_audioCache.contains(identifier)) {
        return m_audioCache[identifier];
    }
    qWarning() << "Audio file not found for:" << identifier;
    return QString();
}

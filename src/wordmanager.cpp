#include "wordmanager.h"
#include <QDebug>

WordManager::WordManager(QObject *parent)
    : QObject(parent), m_currentDifficulty("Easy")
{
    initializeWordDatabase();
}

QStringList WordManager::currentWords() const
{
    return m_currentWords;
}

QString WordManager::currentDifficulty() const
{
    return m_currentDifficulty;
}

void WordManager::setCurrentDifficulty(const QString &difficulty)
{
    if (m_currentDifficulty != difficulty) {
        m_currentDifficulty = difficulty;
        m_currentWords = m_wordsByDifficulty.value(difficulty, QStringList());
        emit difficultyChanged();
        emit wordsChanged();
    }
}

QStringList WordManager::getWordsForDifficulty(const QString &difficulty)
{
    return m_wordsByDifficulty.value(difficulty, QStringList());
}

WordData WordManager::getWordData(const QString &word)
{
    return m_wordDatabase.value(word, WordData());
}

QStringList WordManager::getLettersForWord(const QString &word)
{
    QStringList letters;
    for (QChar c : word) {
        letters.append(QString(c));
    }
    return letters;
}

bool WordManager::isBadgeEarned(const QString &difficulty, int score)
{
    // Badge earning criteria
    if (difficulty == "Easy" && score >= 80)
        return true;
    if (difficulty == "Medium" && score >= 85)
        return true;
    if (difficulty == "Hard" && score >= 90)
        return true;
    return false;
}

QString WordManager::getBadgeForScore(int score)
{
    if (score >= 95)
        return "🏆 Perfect Master";
    else if (score >= 90)
        return "⭐ Expert";
    else if (score >= 80)
        return "🎯 Proficient";
    else if (score >= 70)
        return "📚 Learner";
    else
        return "🌱 Beginner";
}

void WordManager::initializeWordDatabase()
{
    // Easy difficulty - 3 letter words
    QStringList easyWords = {
        "cat", "dog", "bat", "rat", "hat", "mat", "sat", "pat",
        "ant", "art", "arm", "are", "ate", "age", "ace", "ape"
    };

    for (const auto &word : easyWords) {
        WordData data;
        data.word = word;
        data.difficulty = "Easy";
        data.minAccuracy = 70;
        data.timeLimit = 30000; // 30 seconds

        for (QChar c : word) {
            data.letters.append(QString(c));
        }

        m_wordDatabase[word] = data;
    }

    m_wordsByDifficulty["Easy"] = easyWords;

    // Medium difficulty - 4 letter words
    QStringList mediumWords = {
        "book", "look", "cook", "took", "hook", "good", "food", "wood",
        "ball", "call", "fall", "tall", "wall", "bell", "cell", "tell"
    };

    for (const auto &word : mediumWords) {
        WordData data;
        data.word = word;
        data.difficulty = "Medium";
        data.minAccuracy = 75;
        data.timeLimit = 40000; // 40 seconds

        for (QChar c : word) {
            data.letters.append(QString(c));
        }

        m_wordDatabase[word] = data;
    }

    m_wordsByDifficulty["Medium"] = mediumWords;

    // Hard difficulty - mixed 3-4 letter words with complex shapes
    QStringList hardWords = {
        "bird", "tree", "fish", "jump", "play", "read", "write", "think",
        "apple", "orange", "grape", "lemon", "peach", "berry"
    };

    for (const auto &word : hardWords) {
        WordData data;
        data.word = word;
        data.difficulty = "Hard";
        data.minAccuracy = 80;
        data.timeLimit = 50000; // 50 seconds

        for (QChar c : word) {
            data.letters.append(QString(c));
        }

        m_wordDatabase[word] = data;
    }

    m_wordsByDifficulty["Hard"] = hardWords;

    // Set initial words
    m_currentWords = easyWords;
}

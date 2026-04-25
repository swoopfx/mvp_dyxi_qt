#ifndef WORDMANAGER_H
#define WORDMANAGER_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QJsonObject>

struct WordData {
    QString word;
    QStringList letters;
    QString difficulty;
    int minAccuracy;
    int timeLimit;
};

class WordManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList currentWords READ currentWords NOTIFY wordsChanged)
    Q_PROPERTY(QString currentDifficulty READ currentDifficulty WRITE setCurrentDifficulty NOTIFY difficultyChanged)

public:
    explicit WordManager(QObject *parent = nullptr);

    QStringList currentWords() const;
    QString currentDifficulty() const;
    void setCurrentDifficulty(const QString &difficulty);

    Q_INVOKABLE QStringList getWordsForDifficulty(const QString &difficulty);
    Q_INVOKABLE WordData getWordData(const QString &word);
    Q_INVOKABLE QStringList getLettersForWord(const QString &word);
    Q_INVOKABLE bool isBadgeEarned(const QString &difficulty, int score);
    Q_INVOKABLE QString getBadgeForScore(int score);

signals:
    void wordsChanged();
    void difficultyChanged();
    void badgeEarned(const QString &badgeName);

private:
    QStringList m_currentWords;
    QString m_currentDifficulty;
    QMap<QString, QStringList> m_wordsByDifficulty;
    QMap<QString, WordData> m_wordDatabase;

    void initializeWordDatabase();
};

#endif // WORDMANAGER_H

#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QVariantList>
#include <QDateTime>

class GameEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentQuestionValue READ currentQuestionValue NOTIFY currentQuestionValueChanged)
    Q_PROPERTY(int targetBond READ targetBond CONSTANT)
    Q_PROPERTY(QString difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)
    Q_PROPERTY(int score READ score NOTIFY scoreChanged)

public:
    explicit GameEngine(QObject *parent = nullptr);

    int currentQuestionValue() const { return m_currentQuestionValue; }
    int targetBond() const { return 10; }
    QString difficulty() const { return m_difficulty; }
    void setDifficulty(const QString &difficulty);
    int score() const { return m_score; }

    Q_INVOKABLE void startNewGame();
    Q_INVOKABLE void nextQuestion();
    Q_INVOKABLE bool checkAnswer(int placedCounters);

signals:
    void currentQuestionValueChanged();
    void difficultyChanged();
    void scoreChanged();
    void questionAsked(int value, QDateTime time);
    void answerSubmitted(bool success, int value, QDateTime time);

private:
    int m_currentQuestionValue;
    QString m_difficulty;
    int m_score;
    void generateQuestion();
};

#endif // GAMEENGINE_H

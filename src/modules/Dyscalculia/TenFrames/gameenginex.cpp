#include "gameenginex.h"
#include <QRandomGenerator>

GameEnginex::GameEnginex(QObject *parent)
    : QObject(parent), m_currentQuestionValue(0), m_difficulty("Easy"), m_score(0)
{
}

void GameEnginex::setDifficulty(const QString &difficulty)
{
    if (m_difficulty != difficulty) {
        m_difficulty = difficulty;
        emit difficultyChanged();
    }
}

void GameEnginex::startNewGame()
{
    m_score = 0;
    emit scoreChanged();
    nextQuestion();
}

void GameEnginex::nextQuestion()
{
    generateQuestion();
    emit questionAsked(m_currentQuestionValue, QDateTime::currentDateTime());
}

bool GameEnginex::checkAnswer(int placedCounters)
{
    bool success = (m_currentQuestionValue + placedCounters == 10);
    if (success) {
        m_score++;
        emit scoreChanged();
    }
    emit answerSubmitted(success, placedCounters, QDateTime::currentDateTime());
    return success;
}

void GameEnginex::generateQuestion()
{
    int maxVal = (m_difficulty == "Easy") ? 5 : 9;
    m_currentQuestionValue = QRandomGenerator::global()->bounded(1, maxVal + 1);
    emit currentQuestionValueChanged();
}

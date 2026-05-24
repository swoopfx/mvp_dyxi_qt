#include "gameengine.h"
#include <QRandomGenerator>

GameEngine::GameEngine(QObject *parent)
    : QObject(parent), m_currentQuestionValue(0), m_difficulty("Easy"), m_score(0)
{
}

void GameEngine::setDifficulty(const QString &difficulty)
{
    if (m_difficulty != difficulty) {
        m_difficulty = difficulty;
        emit difficultyChanged();
    }
}

void GameEngine::startNewGame()
{
    m_score = 0;
    emit scoreChanged();
    nextQuestion();
}

void GameEngine::nextQuestion()
{
    generateQuestion();
    emit questionAsked(m_currentQuestionValue, QDateTime::currentDateTime());
}

bool GameEngine::checkAnswer(int placedCounters)
{
    bool success = (m_currentQuestionValue + placedCounters == 10);
    if (success) {
        m_score++;
        emit scoreChanged();
    }
    emit answerSubmitted(success, placedCounters, QDateTime::currentDateTime());
    return success;
}

void GameEngine::generateQuestion()
{
    int maxVal = (m_difficulty == "Easy") ? 5 : 9;
    m_currentQuestionValue = QRandomGenerator::global()->bounded(1, maxVal + 1);
    emit currentQuestionValueChanged();
}

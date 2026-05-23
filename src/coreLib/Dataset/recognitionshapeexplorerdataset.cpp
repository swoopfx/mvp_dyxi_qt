#include "recognitionshapeexplorerdataset.h"

RecognitionShapeExplorerDataset::RecognitionShapeExplorerDataset(AbstractErrorProcessing *parent)
    : AbstractErrorProcessing{parent}
{}

QString RecognitionShapeExplorerDataset::pageName() const
{
    return m_pageName;
}

void RecognitionShapeExplorerDataset::setPageName(const QString &newPageName)
{
    if (m_pageName == newPageName)
        return;
    m_pageName = newPageName;
    emit pageNameChanged();
}

QString RecognitionShapeExplorerDataset::studentId() const
{
    return m_studentId;
}

void RecognitionShapeExplorerDataset::setStudentId(const QString &newStudentId)
{
    if (m_studentId == newStudentId)
        return;
    m_studentId = newStudentId;
    emit studentIdChanged();
}

QString RecognitionShapeExplorerDataset::gameId() const
{
    return m_gameId;
}

void RecognitionShapeExplorerDataset::setGameId(const QString &newGameId)
{
    if (m_gameId == newGameId)
        return;
    m_gameId = newGameId;
    emit gameIdChanged();
}

QString RecognitionShapeExplorerDataset::gameType() const
{
    return m_gameType;
}

void RecognitionShapeExplorerDataset::setGameType(const QString &newGameType)
{
    if (m_gameType == newGameType)
        return;
    m_gameType = newGameType;
    emit gameTypeChanged();
}

QString RecognitionShapeExplorerDataset::gameCategory() const
{
    return m_gameCategory;
}

void RecognitionShapeExplorerDataset::setGameCategory(const QString &newGameCategory)
{
    if (m_gameCategory == newGameCategory)
        return;
    m_gameCategory = newGameCategory;
    emit gameCategoryChanged();
}

QString RecognitionShapeExplorerDataset::activity() const
{
    return m_activity;
}

void RecognitionShapeExplorerDataset::setActivity(const QString &newActivity)
{
    if (m_activity == newActivity)
        return;
    m_activity = newActivity;
    emit activityChanged();
}

QString RecognitionShapeExplorerDataset::userId() const
{
    return m_userId;
}

void RecognitionShapeExplorerDataset::setuserId(const QString &newUserId)
{
    if (m_userId == newUserId)
        return;
    m_userId = newUserId;
    emit userIdChanged();
}

float RecognitionShapeExplorerDataset::problemSolvingIndex() const
{
    return m_problemSolvingIndex;
}

void RecognitionShapeExplorerDataset::setProblemSolvingIndex(float newProblemSolvingIndex)
{
    if (qFuzzyCompare(m_problemSolvingIndex, newProblemSolvingIndex))
        return;
    m_problemSolvingIndex = newProblemSolvingIndex;
    emit problemSolvingIndexChanged();
}

float RecognitionShapeExplorerDataset::creativeIndex() const
{
    return m_creativeIndex;
}

void RecognitionShapeExplorerDataset::setCreativeIndex(float newCreativeIndex)
{
    if (qFuzzyCompare(m_creativeIndex, newCreativeIndex))
        return;
    m_creativeIndex = newCreativeIndex;
    emit creativeIndexChanged();
}

float RecognitionShapeExplorerDataset::averageTimeCorrect() const
{
    return m_averageTimeCorrect;
}

void RecognitionShapeExplorerDataset::setAverageTimeCorrect(float newAverageTimeCorrect)
{
    if (qFuzzyCompare(m_averageTimeCorrect, newAverageTimeCorrect))
        return;
    m_averageTimeCorrect = newAverageTimeCorrect;
    emit averageTimeCorrectChanged();
}

float RecognitionShapeExplorerDataset::averageTimeFailed() const
{
    return m_averageTimeFailed;
}

void RecognitionShapeExplorerDataset::setAverageTimeFailed(float newAverageTimeFailed)
{
    if (qFuzzyCompare(m_averageTimeFailed, newAverageTimeFailed))
        return;
    m_averageTimeFailed = newAverageTimeFailed;
    emit averageTimeFailedChanged();
}

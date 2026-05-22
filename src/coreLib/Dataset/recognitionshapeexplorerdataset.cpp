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

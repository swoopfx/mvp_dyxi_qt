#ifndef RECOGNITIONSHAPEEXPLORERDATASET_H
#define RECOGNITIONSHAPEEXPLORERDATASET_H

#include <QObject>
#include <QQmlEngine>
#include "../General/postactivity.h"
#include "../General/abstracterrorprocessing.h"

class RecognitionShapeExplorerDataset : public AbstractErrorProcessing
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString pageName READ pageName WRITE setPageName NOTIFY pageNameChanged FINAL)
    Q_PROPERTY(QString studentId READ studentId WRITE setStudentId NOTIFY studentIdChanged FINAL)
    Q_PROPERTY(QString gameId READ gameId WRITE setGameId NOTIFY gameIdChanged FINAL)
    Q_PROPERTY(QString gameLevel READ gameLevel WRITE setgameLevel NOTIFY gameLevelChanged FINAL)
    Q_PROPERTY(QString gameType READ gameType WRITE setGameType NOTIFY gameTypeChanged FINAL) // defaults to tracing
    Q_PROPERTY(QString gameCategory READ gameCategory WRITE setGameCategory NOTIFY gameCategoryChanged FINAL)
    Q_PROPERTY(float problemSolvingIndex READ problemSolvingIndex WRITE setProblemSolvingIndex NOTIFY problemSolvingIndexChanged FINAL)
    Q_PROPERTY(float creativeIndex READ creativeIndex WRITE setCreativeIndex NOTIFY creativeIndexChanged FINAL)
    Q_PROPERTY(float averageTimeCorrect READ averageTimeCorrect WRITE setAverageTimeCorrect NOTIFY averageTimeCorrectChanged FINAL)
    Q_PROPERTY(float averageTimeFailed READ averageTimeFailed WRITE setAverageTimeFailed NOTIFY averageTimeFailedChanged FINAL)
    Q_PROPERTY(QString activity READ activity WRITE setActivity NOTIFY activityChanged FINAL)

public:
    explicit RecognitionShapeExplorerDataset(AbstractErrorProcessing *parent = nullptr);

    QString pageName() const;
    void setPageName(const QString &newPageName);

    QString studentId() const;
    void setStudentId(const QString &newStudentId);

    QString gameId() const;
    void setGameId(const QString &newGameId);

    QString gameType() const;
    void setGameType(const QString &newGameType);

    QString gameCategory() const;
    void setGameCategory(const QString &newGameCategory);

    QString activity() const;
    void setActivity(const QString &newActivity);

signals:
    void pageNameChanged();
    void studentIdChanged();

    void gameIdChanged();

    void gameTypeChanged();

    void gameCategoryChanged();

    void activityChanged();

private:
    QString m_pageName;
    QString m_studentId;
    QString m_gameId;
    QString m_gameType;
    QString m_gameCategory;
    QString m_activity;

    PostActivity *postActivity;
};

#endif // RECOGNITIONSHAPEEXPLORERDATASET_H

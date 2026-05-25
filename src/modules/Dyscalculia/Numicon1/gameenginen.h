#ifndef GAMEENGINEN_H
#define GAMEENGINEN_H

#include <QObject>
#include <QVariantMap>
#include <QQmlEngine>

class GameEnginen : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit GameEnginen(QObject *parent = nullptr);

    Q_INVOKABLE QVariantMap generateTask(int difficulty);
    Q_INVOKABLE bool checkAnswer(int target, int input);

private:
    int m_difficulty = 1;
};

#endif // GAMEENGINEN_H

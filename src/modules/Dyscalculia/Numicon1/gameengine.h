#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QVariantMap>

class GameEngine : public QObject
{
    Q_OBJECT
public:
    explicit GameEngine(QObject *parent = nullptr);

    Q_INVOKABLE QVariantMap generateTask(int difficulty);
    Q_INVOKABLE bool checkAnswer(int target, int input);

private:
    int m_difficulty = 1;
};

#endif // GAMEENGINE_H

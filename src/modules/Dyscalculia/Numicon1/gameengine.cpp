#include "gameengine.h"
#include <QRandomGenerator>

GameEngine::GameEngine(QObject *parent) : QObject(parent) {}

QVariantMap GameEngine::generateTask(int difficulty) {
    QVariantMap task;
    int target, val1, val2;

    switch(difficulty) {
        case 1: // Recognition
            target = QRandomGenerator::global()->bounded(1, 11);
            task["type"] = "recognition";
            task["target"] = target;
            break;
        case 2: // Addition
            target = QRandomGenerator::global()->bounded(2, 11);
            val1 = QRandomGenerator::global()->bounded(1, target);
            task["type"] = "addition";
            task["target"] = target;
            task["val1"] = val1;
            task["required"] = target - val1;
            break;
        case 3: // Mental Math
            target = QRandomGenerator::global()->bounded(5, 21);
            task["type"] = "complex";
            task["target"] = target;
            break;
    }
    return task;
}

bool GameEngine::checkAnswer(int target, int input) {
    return target == input;
}

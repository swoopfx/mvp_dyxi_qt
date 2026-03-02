#include "dyxlearnengine.h"

DyxLearnEngine::DyxLearnEngine(QObject *parent)
    : QObject{parent}
{}

void DyxLearnEngine::recordAnswer(QString letter, bool correct)
{
    if(!correct)
        mistakeTracker[letter]++;
}

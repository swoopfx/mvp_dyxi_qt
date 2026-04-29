#include "tt.h"

TT::TT(QObject *parent)
    : QObject{parent}
{
    qInfo() << "hey";
    qInfo() << "I dont know what is this";
}

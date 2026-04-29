#include "ano.h"

ANO::ANO(QObject *parent)
    : QObject{parent}
{
    qInfo() << "Another here";
}

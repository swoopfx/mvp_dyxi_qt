#include "settings.h"


Settings::Settings(QObject *parent)
    : QObject{parent}
{
    settings = new QSettings(this);
}

QVariantMap Settings::studentMap() const
{
    return m_studentMap;
}

void Settings::setStudentMap(const QVariantMap &newStudentMap)
{
    m_studentMap = newStudentMap;
}

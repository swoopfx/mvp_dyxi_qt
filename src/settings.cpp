#include "settings.h"
#include <QCoreApplication>


Settings::Settings(QObject *parent)
    : QObject{parent}
{
    m_settings = new QSettings(QCoreApplication::organizationName(), QCoreApplication::applicationName(), this);
}

QVariantMap Settings::studentMap() const
{
    return m_studentMap;
}

void Settings::setStudentMap(const QVariantMap &newStudentMap)
{
    m_studentMap = newStudentMap;
}

QVariant Settings::actvieUserId() const
{
    return m_actvieUserId;
}

QVariant Settings::activeuserName() const
{
    return m_activeuserName;
}

void Settings::setActiveuserName(const QVariant &newActiveuserName)
{
    if (m_activeuserName == newActiveuserName)
        return;
    m_activeuserName = newActiveuserName;
    emit activeuserNameChanged();
}



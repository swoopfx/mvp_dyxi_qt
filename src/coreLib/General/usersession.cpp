#include "usersession.h"

UserSession::UserSession(QObject *parent)
    : QObject{parent}
{}

UserSession* UserSession::instance() {
    static UserSession* instance = new UserSession();
    return instance;
}

QString UserSession::userId() const
{
    return m_userId;
}

void UserSession::setUserId(const QString &newUserId)
{
    if (m_userId == newUserId)
        return;
    m_userId = newUserId;
    emit userIdChanged();
}

QString UserSession::userFullName() const
{
    return m_userFullName;
}

void UserSession::setUserFullName(const QString &newUserFullName)
{
    if (m_userFullName == newUserFullName)
        return;
    m_userFullName = newUserFullName;
    emit userFullNameChanged();
}

QString UserSession::userAge() const
{
    return m_userAge;
}



void UserSession::setUserAge(const QString &newUserAge)
{
    if (m_userAge == newUserAge)
        return;
    m_userAge = newUserAge;
    emit userAgeChanged();
}

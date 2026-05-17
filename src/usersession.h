#ifndef USERSESSION_H
#define USERSESSION_H

#include <QObject>
#include <QQmlEngine>
#include <QString>

class UserSession : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    // Make it a Singleton Implementation

     Q_PROPERTY(QString userId READ userId WRITE setUserId NOTIFY userIdChanged)
    Q_PROPERTY(QString userFullName READ userFullName WRITE setUserFullName NOTIFY userFullNameChanged FINAL)
public:
    static UserSession* instance();

    QString userId() const;
    void setUserId(const QString &newUserId);

    QString userFullName() const;
    void setUserFullName(const QString &newUserFullName);

signals:
    void userIdChanged();
    void userFullNameChanged();

private:
    QString m_userId;
    QString m_userFullName;
    explicit UserSession(QObject *parent = nullptr);

};

#endif // USERSESSION_H

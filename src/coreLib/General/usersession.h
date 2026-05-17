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
     Q_PROPERTY(QString userAge READ userAge WRITE setUserAge NOTIFY userAgeChanged FINAL)
public:
    static UserSession* instance();

    QString userId() const;
    void setUserId(const QString &newUserId);

    QString userFullName() const;
    void setUserFullName(const QString &newUserFullName);

    QString userAge() const;
    void setUserAge(const QString &newUserAge);

signals:
    void userIdChanged();
    void userFullNameChanged();

    void userAgeChanged();

private:
    QString m_userId;
    QString m_userFullName;
    // QString m_useAge;
    explicit UserSession(QObject *parent = nullptr);

    QString m_userAge;
};

#endif // USERSESSION_H

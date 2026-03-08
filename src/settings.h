#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT

    // QSettings *settings;
public:
    explicit Settings(QObject *parent = nullptr);


    QVariantMap studentMap() const;
    void setStudentMap(const QVariantMap &newStudentMap);

    QVariant actvieUserId() const;

    QVariant activeuserName() const;
    void setActiveuserName(const QVariant &newActiveuserName);


signals:

    void activeuserNameChanged();

private:
    QSettings *m_settings;
    QVariantMap m_studentMap;
    QVariant m_actvieUserId;
    QVariant m_activeuserName;
    QVariant m_activeUserUuid;
    QVariant m_activeUserLanguane;
    // Q_PROPERTY(QSettings *settings READ Settings CONSTANT FINAL)
    Q_PROPERTY(QVariant actvieUserId READ actvieUserId CONSTANT FINAL)
    Q_PROPERTY(QVariant activeuserName READ activeuserName WRITE setActiveuserName NOTIFY activeuserNameChanged FINAL)
};

#endif // SETTINGS_H

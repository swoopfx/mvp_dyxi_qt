#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT

    QSettings *settings;
public:
    explicit Settings(QObject *parent = nullptr);

    QVariantMap studentMap() const;
    void setStudentMap(const QVariantMap &newStudentMap);

signals:

private:
    QSettings *m_settings;
    QVariantMap m_studentMap;
    // Q_PROPERTY(QSettings *settings READ Settings CONSTANT FINAL)
};

#endif // SETTINGS_H

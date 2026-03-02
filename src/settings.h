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

signals:

private:
    QSettings *m_settings;
    QVariantMap m_studentMap;
};

#endif // SETTINGS_H

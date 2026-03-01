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
};

#endif // SETTINGS_H

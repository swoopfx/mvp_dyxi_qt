#ifndef MMM_H
#define MMM_H

#include <QObject>
#include <QQmlEngine>

class MMM : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit MMM(QObject *parent = nullptr);

signals:
};

#endif // MMM_H

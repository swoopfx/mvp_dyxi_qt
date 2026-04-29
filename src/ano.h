#ifndef ANO_H
#define ANO_H

#include <QObject>
#include <QQmlEngine>

class ANO : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit ANO(QObject *parent = nullptr);

signals:
};

#endif // ANO_H

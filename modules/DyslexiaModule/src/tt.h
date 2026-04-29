#ifndef TT_H
#define TT_H

#include <QObject>
#include <QQmlEngine>

class TT : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit TT(QObject *parent = nullptr);

signals:
};

#endif // TT_H

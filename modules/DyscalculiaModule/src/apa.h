#ifndef APA_H
#define APA_H

#include <QObject>
#include <QQmlEngine>

class APA : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit APA(QObject *parent = nullptr);

signals:
};

#endif // APA_H

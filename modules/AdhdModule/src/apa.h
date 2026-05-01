#ifndef APA_H
#define APA_H

#include <QObject>
#include <QQmlEngine>

namespace AdhdModule {

 Q_NAMESPACE


class APA : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit APA(QObject *parent = nullptr);

signals:
};

} // namespace AdhdModule

#endif // APA_H

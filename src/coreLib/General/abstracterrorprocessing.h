#ifndef ABSTRACTERRORPROCESSING_H
#define ABSTRACTERRORPROCESSING_H

#include <QObject>
#include <QQmlEngine>
#include <QtQml>

class AbstractErrorProcessing : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("Error Processing Abstract Class ")
public:
    explicit AbstractErrorProcessing(QObject *parent = nullptr);
    virtual  ~AbstractErrorProcessing()= default;
    // virtual void start() = 0;

signals:
    void requestFailed(const QString &error);
    void requestFinished(const QString &response);

};

#endif // ABSTRACTERRORPROCESSING_H

#ifndef POSTACTIVITY_H
#define POSTACTIVITY_H

#include <QObject>
#include <QQmlEngine>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QByteArray>

class PostActivity : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit PostActivity(QObject *parent = nullptr);

signals:


public slots:
    void handlePostReqest(QByteArray, QNetworkRequest); // handles all post request by the app

};

#endif // POSTACTIVITY_H

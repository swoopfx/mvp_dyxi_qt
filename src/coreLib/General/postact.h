#ifndef POSTACT_H
#define POSTACT_H

#include <QObject>
#include <QQmlEngine>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QByteArray>
#include <QJsonObject>

class PostAct : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit PostAct(QObject *parent = nullptr);

signals:
    void dataPostedSuccessfully(const QJsonObject &responseData);
    void requestError(const QString &errorString);


public slots:
    void handlePostReqest(const QByteArray &data, const QNetworkRequest &request); // handles all post request by the app

private slots:
    void onReplyFinished(QNetworkReply *reply);
    void onSslErrors(QNetworkReply *reply, const QList<QSslError> &errors);

private:
    QNetworkAccessManager *manager;
};

#endif // POSTACT_H

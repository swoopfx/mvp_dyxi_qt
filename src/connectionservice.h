#ifndef CONNECTIONSERVICE_H
#define CONNECTIONSERVICE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>
#include <QVariantMap>
#include <QDebug>

class ConnectionService : public QObject
{
    Q_OBJECT

    QNetworkAccessManager *manager;
    Q_PROPERTY(QVariantMap studentDetails READ studentDetails NOTIFY studentDetailsChanged);
    Q_PROPERTY(bool isLoadingData READ isLoadingData  NOTIFY isLoadingDataChanged );
public:
    explicit ConnectionService(QObject *parent = nullptr);
    bool isLoadingData() const{return m_isLoadingData;}
    Q_INVOKABLE void getStudentDetailsApiRequest(const QString &url);
    Q_INVOKABLE void helloworld(){
        qDebug() << "Hello to Button";
    }


signals:
    void  apiGetdetails();
    void studentDetailsChanged();
    void isLoadingDataChanged();
    void requestFinished(const QString &response);
    void  requestFailed(const QString &error);

private slots:
    void onGetStudentDetailApiFinished(QNetworkReply *reply);

private:
    QVariantMap m_studentDetails;
    bool m_isLoadingData = false;
    QVariantMap studentDetails() const{return m_studentDetails;}

    void setIsLoadingData(bool loading);


};

#endif // CONNECTIONSERVICE_H

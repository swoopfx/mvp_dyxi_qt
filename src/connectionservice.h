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
#include  <QSettings>

class ConnectionService : public QObject
{
    Q_OBJECT

    QNetworkAccessManager *manager;
    Q_PROPERTY(QVariantMap studentDetails READ studentDetails NOTIFY studentDetailsChanged);
    Q_PROPERTY(QVariantMap studentDataMap READ studentDataMap WRITE setStudentDataMap  NOTIFY studentDataMapChanged )
    Q_PROPERTY(bool isLoadingData READ isLoadingData  NOTIFY isLoadingDataChanged );
public:
    explicit ConnectionService(QObject *parent = nullptr);
    bool isLoadingData() const{return m_isLoadingData;}
    Q_INVOKABLE void getStudentDetailsApiRequest(const QString &url);
    Q_INVOKABLE void helloworld(){
        qDebug() << "Hello to Button";
    }
    void setStudentDataMap(QVariantMap studentDataMap);

public:
    QVariantMap studentDataMap() const {return  m_studentDataMap;}

signals:
    void  apiGetdetails();
    void studentDetailsChanged();
    void studentDataMapChanged();
    void isLoadingDataChanged();
    void requestFinished(const QString &response);
    void  requestFailed(const QString &error);
    void changePage(const QString &pageName);

private slots:
    void onGetStudentDetailApiFinished(QNetworkReply *reply);

private:
    QVariantMap m_studentDetails;
    QVariantMap m_studentDataMap;
    bool m_isLoadingData = false;
    QVariantMap studentDetails() const{return m_studentDetails;}

    void setIsLoadingData(bool loading);


};

#endif // CONNECTIONSERVICE_H

#ifndef NEWORKACCESSMANAGER_H
#define NEWORKACCESSMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>
#include <QVariantMap>
#include <QDebug>
#include <QQmlEngine>


class NeworkAccessManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QVariantMap profile READ profile WRITE setProfile NOTIFY profileChanged FINAL)
    Q_PROPERTY(QVariantMap profileDataMap READ profileDataMap WRITE setprofileDataMap NOTIFY profileDataMapChanged FINAL)
     Q_PROPERTY(bool isLoadingData READ isLoadingData  NOTIFY isLoadingDataChanged );

public:
    explicit NeworkAccessManager(QObject *parent = nullptr);
    bool isLoadingData() const{return m_isLoadingData;}
    Q_INVOKABLE void getProfileApiRequest(const QString &url);
    Q_INVOKABLE void getGamesApiRequest(const QString &url);

    QVariantMap profile() const;
    void setProfile(const QVariantMap &newProfile);

    QVariantMap profileDataMap() const;
    void setprofileDataMap(const QVariantMap &newProfileDataMap);

signals:

    void profileChanged();
    void profileDataMapChanged();
    void requestFailed(const QString &error);
    void requestFinished(const QString &response);

    void isLoadingDataChanged();
     void changePage(const QString &pageName);

private slots:
    void onGetProfileDetailsApiFinished(QNetworkReply *reply);


private:
    QNetworkAccessManager* manager;
    QVariantMap m_profile;
    QVariantMap m_profileDataMap;
    bool m_isLoadingData = false;

    void setIsLoadingData(bool loading);

};

#endif // NEWORKACCESSMANAGER_H

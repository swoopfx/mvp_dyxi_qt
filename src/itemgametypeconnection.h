#ifndef ITEMGAMETYPECONNECTION_H
#define ITEMGAMETYPECONNECTION_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>
#include <QVariantMap>
#include <QList>
#include <QQmlEngine>


class ItemGameTypeConnection : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QList<QVariantMap> itemGameType READ itemGameType  NOTIFY itemGameTypeChanged)
    Q_PROPERTY(bool isLoadingData READ isLoadingData  NOTIFY isLoadingDataChanged )
    Q_PROPERTY(bool isLoadedData READ isLoadedData WRITE setIsLoadedData NOTIFY isLoadedDataChanged FINAL)

    Q_PROPERTY(QVariantMap singleDataResponse READ singleDataResponse NOTIFY singleDataResponseChanged);

    QNetworkAccessManager *manager;
    QList<QVariantMap> m_itemGameType;

    bool m_isLoadingData = false;
    bool isLoadingData() const{return m_isLoadingData;}

    void setIsLoadingData(bool loading);
    // Q_INVOKABLE void getItemGameType(const QString &url);

public:
    explicit ItemGameTypeConnection(QObject *parent = nullptr);
    Q_INVOKABLE void itemGameTypeApiRequest(const QString &url);
    Q_INVOKABLE void singleDataApiRequest(const QString &url);
    void setItemGameType(QList<QVariantMap> itemGameType);
    QList<QVariantMap> itemGameType() const{return m_itemGameType;}

    bool isLoadedData() const{return m_isLoadedData;};
    void setisLoadedData(bool newIsLoadedData);

    void setIsLoadedData(bool newIsLoadedData);

    QVariantMap singleDataResponse() const;

signals:
    void itemGameTypeChanged();
    void isLoadingDataChanged();
    void requestFinished();
    void requestFailed(const QString $str);
    void requesFinished(const QString $response);

    void isLoadedDataChanged();

    void singleDataResponseChanged();

private slots:
    void onGetItemGameTypeFinished(QNetworkReply *reply);
    void onSingleDataRequestFinished(QNetworkReply *reply);

private:
    bool m_isLoadedData;
    QVariantMap m_singleDataResponse;
};

#endif // ITEMGAMETYPECONNECTION_H

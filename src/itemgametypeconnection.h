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


class ItemGameTypeConnection : public QObject
{
    Q_OBJECT


    Q_PROPERTY(QList<QVariantMap> itemGameType READ itemGameType  NOTIFY itemGameTypeChanged)

    QNetworkAccessManager *manager;
    QList<QVariantMap> m_itemGameType;

    bool m_isLoadingData = false;

    void setIsLoadingData(bool loading);
    // Q_INVOKABLE void getItemGameType(const QString &url);

public:
    explicit ItemGameTypeConnection(QObject *parent = nullptr);
    Q_INVOKABLE void itemGameTypeApiRequest(const QString &url);
    void setItemGameType(QList<QVariantMap> itemGameType);
    QList<QVariantMap> itemGameType() const{return m_itemGameType;}

signals:
    void itemGameTypeChanged();
    void isLoadingDataChanged();
    void requestFinished();
    void requestFailed(const QString $str);

private slots:
    void onGetItemGameTypeFinished(QNetworkReply *reply);

};

#endif // ITEMGAMETYPECONNECTION_H

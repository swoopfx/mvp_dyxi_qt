#ifndef NETWORKACCESSPRESETS_H
#define NETWORKACCESSPRESETS_H

#include <QQmlEngine>
#include <QVariantMap>
#include <QVariantList>
#include <QNetworkAccessManager>
#include "abstracterrorprocessing.h"

class NetworkAccessPresets : public AbstractErrorProcessing
{
     Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QVariantList gameTypeIds READ gameTypeIds WRITE setGameTypeIds NOTIFY gameTypeIdsChanged FINAL)
    // Q_PROPERTY(bool isLoadedData READ isLoadedData WRITE setIsLoadedData NOTIFY isLoadedDataChanged FINAL)
    Q_PROPERTY(QVariantMap gameCategoryIds READ gameCategoryIds WRITE setGameCategoryIds NOTIFY gameCategoryIdsChanged FINAL)

public:
    explicit NetworkAccessPresets(QObject *parent = nullptr);
    Q_INVOKABLE void getGameTypeIdRequest(const QString &url);
    QVariantList gameTypeIds() const;
    void setGameTypeIds(const QVariantList &newGameTypeIds);
    QVariantMap gameCategoryIds() const;
    void setGameCategoryIds(const QVariantMap &newGameCategoryIds);

signals:
    void gameTypeIdsChanged();

    void gameCategoryIdsChanged();

private slots:
    void onGameTypeIdFinished(QNetworkReply *reply);
private:
    QVariantList m_gameTypeIds;
    QNetworkAccessManager *manager;

    QVariantMap m_gameCategoryIds;
};

#endif // NETWORKACCESSPRESETS_H

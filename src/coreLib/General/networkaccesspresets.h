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
    Q_PROPERTY(QVariantList gameCategoryIds READ gameCategoryIds WRITE setGameCategoryIds NOTIFY gameCategoryIdsChanged FINAL)

public:
    explicit NetworkAccessPresets(QObject *parent = nullptr);
    Q_INVOKABLE void getGameTypeIdRequest(const QString &url);
    Q_INVOKABLE void getGameCategoryIdRequest(const QString &url);
    QVariantList gameTypeIds() const;
    void setGameTypeIds(const QVariantList &newGameTypeIds);
    QVariantList gameCategoryIds() const;
    void setGameCategoryIds(const QVariantList &newGameCategoryIds);

signals:
    void gameTypeIdsChanged();

    void gameCategoryIdsChanged();

private slots:
    void onGameTypeIdFinished(QNetworkReply *reply);
    void onGamecategoryIdFinished(QNetworkReply *reply);
private:
    QVariantList m_gameTypeIds;
    QNetworkAccessManager *manager;

    QVariantList m_gameCategoryIds;
};

#endif // NETWORKACCESSPRESETS_H

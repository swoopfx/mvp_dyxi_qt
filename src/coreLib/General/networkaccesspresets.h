#ifndef NETWORKACCESSPRESETS_H
#define NETWORKACCESSPRESETS_H

#include <QQmlEngine>
#include <QVariantMap>
#include "abstracterrorprocessing.h"

class NetworkAccessPresets : public AbstractErrorProcessing
{
    QML_ELEMENT

    Q_PROPERTY(QVariantMap gameTypeIds READ gameTypeIds WRITE setGameTypeIds NOTIFY gameTypeIdsChanged FINAL)
    Q_PROPERTY(bool isLoadedData READ isLoadedData WRITE setIsLoadedData NOTIFY isLoadedDataChanged FINAL)

public:
    explicit NetworkAccessPresets(QObject *parent = nullptr);
    Q_INVOKABLE void getGameTypeIdRequest(const QString &url);
    QVariantMap gameTypeIds() const;
    void setGameTypeIds(const QVariantMap &newGameTypeIds);
signals:
    void gameTypeIdsChanged();

private slots:
    void onGameTypeIdFinished(QNetworkReply *reply);
private:
    QVariantMap m_gameTypeIds;
};

#endif // NETWORKACCESSPRESETS_H

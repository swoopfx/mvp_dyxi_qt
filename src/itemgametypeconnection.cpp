#include "itemgametypeconnection.h"
#include <QJsonArray>
#include <qforeach.h>

void ItemGameTypeConnection::setIsLoadingData(bool loading)
{
    if(m_isLoadingData != loading){
        m_isLoadingData = loading;
        emit isLoadingDataChanged();
    }
}

ItemGameTypeConnection::ItemGameTypeConnection(QObject *parent)
    : QObject{parent}
{
    manager = new QNetworkAccessManager(this);
    setIsLoadingData(false);
    connect(manager, &QNetworkAccessManager::finished, this, &ItemGameTypeConnection::onGetItemGameTypeFinished);
}

void ItemGameTypeConnection::itemGameTypeApiRequest(const QString &url)
{
    setIsLoadingData(true);
    QNetworkRequest request(url);
    manager->get(request);
}

void ItemGameTypeConnection::setItemGameType(QList<QVariantMap> itemGameType)
{
    m_itemGameType = itemGameType;
    emit itemGameTypeChanged();
}

void ItemGameTypeConnection::onGetItemGameTypeFinished(QNetworkReply *reply)
{
    QVariant statusCodeVariant = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    if(reply->error() == QNetworkReply::NoError){

        if(statusCodeVariant.isValid()){
            int statusCode = statusCodeVariant.toInt();

            if(statusCode >=200 && statusCode <300){
                QByteArray responseData = reply->readAll(); // extract all data
                QJsonDocument doc = QJsonDocument::fromJson(responseData);
  setIsLoadingData(false);
                // is not an array
                if(!doc.isArray()){
                    //TODO throw kexception here
                }else if(!doc.isNull() && doc.isObject()){
                    //Convert the document to array
                    QJsonArray jsonArray = doc.array();

                    //  convert to variant list
                    QVariantList variantList = jsonArray.toVariantList();

                    QList<QVariantMap> variantMapList;

                    foreach (const QVariant& variant, variantList) {
                        if (variant.canConvert<QVariantMap>()) {
                            variantMapList.append(variant.toMap());
                        } else {
                            //TODO  throw error if converting from and log error
                            qWarning() << "QVariant is not a QVariantMap, skipping.";
                        }
                    }

                    // setItemGameType
                    setItemGameType(variantMapList);
                }

            }
        }else{
              emit requestFailed("Can Find User");
            setIsLoadingData(false);
        }
    }

     reply->deleteLater();
}



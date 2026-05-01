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
    qInfo() << "I am here now Item GameType connection";
    manager = new QNetworkAccessManager(this);
    setIsLoadingData(false);
    connect(manager, &QNetworkAccessManager::finished, this, &ItemGameTypeConnection::onGetItemGameTypeFinished);
}

void ItemGameTypeConnection::itemGameTypeApiRequest(const QString &url)
{
    setIsLoadingData(true);
    QNetworkRequest request(url);
    manager->get(request);
    qInfo() << "Request Initiated";
}

/**
 * @brief ItemGameTypeConnection::singleDataApiRequest provides functionality for processing single object
 * @param url
 */
void ItemGameTypeConnection::singleDataApiRequest(const QString &url)
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
    qInfo() << "Request finished and processing started";
    if(reply->error() == QNetworkReply::NoError){

        if(statusCodeVariant.isValid()){
            int statusCode = statusCodeVariant.toInt();
            qInfo() << "RProcessingd";
            if(statusCode >=200 && statusCode <300){
                QByteArray responseData = reply->readAll(); // extract all data
                QJsonDocument doc = QJsonDocument::fromJson(responseData);
                setIsLoadingData(false);
                 if(!doc.isNull() && doc.isObject()){
                    //Convert the document to array
                    // QJsonArray jsonArray = doc.array();
                     qInfo() << "isObjectd";
                    QJsonObject jsonObject = doc.object();

                    //Convert to QVariantMap
                    QVariantMap dataMappy = doc.object().toVariantMap();

                    if(!dataMappy.isEmpty()){
                        QVariant data = dataMappy.value("data");
                        QVariantList variantList = data.toList();


                        //  convert to variant list
                        // QVariantList variantList = jsonArray.toVariantList();

                        QList<QVariantMap> variantMapList;
                        qInfo() << "VariantMap";
                        foreach (const QVariant& variant, variantList) {
                            if (variant.canConvert<QVariantMap>()) {
                                variantMapList.append(variant.toMap());
                                // setItemGameType(variantMapList);
                            } else {
                                //TODO  throw error if converting from and log error
                                qWarning() << "QVariant is not a QVariantMap, skipping.";
                                emit requestFailed("Data Conversion Error");
                            }
                        }

                        // int index = 0;
                        // for (const QVariant &v : variantList) {
                        //     // v.toString() works for many types, or use switch(v.userType())
                        //     qDebug() << "Item" << index++ << ":" << v.value<QMap>;

                        //     // If the item is another list or map, handle it recursively
                        //     if (v.canConvert<QVariantList>()) {
                        //         qDebug() << "Nested List:" << v.toList();
                        //     }
                        // }

                        // setItemGameType
                        setItemGameType(variantMapList);
                        setIsLoadedData(true);
                    }
                }else{
                    emit requestFailed("Can Find User");
                }

            }
        }else{
            emit requestFailed("Cant Identify datatype");
            setIsLoadingData(false);
        } // TODO define else condition
    }else{
        emit requestFailed("Network Error");
    }

    reply->deleteLater();
}

void ItemGameTypeConnection::onSingleDataRequestFinished(QNetworkReply *reply)
{

    reply->deleteLater();
}



void ItemGameTypeConnection::setIsLoadedData(bool newIsLoadedData)
{
    // if (m_isLoadedData == newIsLoadedData)
    //     return;
    m_isLoadedData = newIsLoadedData;
    emit isLoadedDataChanged();
}

QVariantMap ItemGameTypeConnection::singleDataResponse() const
{
    return m_singleDataResponse;
}

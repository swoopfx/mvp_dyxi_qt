#include "connectionservice.h"

ConnectionService::ConnectionService(QObject *parent)
    : QObject{parent}
{
    manager = new QNetworkAccessManager(this);
    setIsLoadingData(false);
    connect(manager, &QNetworkAccessManager::finished, this, &ConnectionService::onGetStudentDetailApiFinished);
}

void ConnectionService::getStudentDetailsApiRequest(const QString &url)
{
    setIsLoadingData(true);
    QNetworkRequest request(url);
    // request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json")
    manager->get(request);

}

void ConnectionService::onGetStudentDetailApiFinished(QNetworkReply *reply)
{
    if(reply->error() ==QNetworkReply::NoError){
        QByteArray responseData = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(responseData);

        if(!doc.isNull() && doc.isObject()){
            setIsLoadingData(false);
            m_studentDetails = doc.object().toVariantMap();
            emit studentDetailsChanged();
        }else{
            emit requestFailed("Failsed to Process Document");
        }
    }else{
        emit requestFailed(reply->errorString());
    }

    reply->deleteLater();
}

void ConnectionService::setIsLoadingData(bool loading)
{
    if (m_isLoadingData!= loading){
        m_isLoadingData = loading;
        emit isLoadingDataChanged();
    }
}

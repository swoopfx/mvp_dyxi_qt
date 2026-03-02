#include "connectionservice.h"
#include <QCoreApplication>
#include <QDebug>
#include "AllString.h"

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

void ConnectionService::setStudentDataMap(QVariantMap studentDataMap)
{
    m_studentDataMap = studentDataMap;
    emit studentDataMapChanged();
}

void ConnectionService::onGetStudentDetailApiFinished(QNetworkReply *reply)
{
    QVariant statusCodeVariant = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    if(reply->error() == QNetworkReply::NoError){


        if(statusCodeVariant.isValid()){
            int statusCode = statusCodeVariant.toInt();  // extract status code

            if(statusCode >= 200 && statusCode < 300){
                QByteArray responseData = reply->readAll(); // extract all data
                QJsonDocument doc = QJsonDocument::fromJson(responseData);

                if(!doc.isNull() && doc.isObject()){
                    setIsLoadingData(false);
                    m_studentDetails = doc.object().toVariantMap();
                    if(!m_studentDetails.isEmpty()){
                        QVariant data = m_studentDetails.value("data");
                        QVariantMap dataMap = data.toMap();
                        setStudentDataMap(dataMap);
                        QSettings settings(QCoreApplication::organizationName(), QCoreApplication::applicationName());
                        settings.setValue(AllString::activeUserId, dataMap.value("id"));
                        settings.setValue(AllString::activeUserName, dataMap.value("studentName"));
                        settings.setValue(AllString::activeUserUuid, dataMap.value("uuid"));
                        settings.setValue(AllString::activeUserLanguage, "english");

                        qDebug() << dataMap.value("studentName");

                        emit studentDetailsChanged();
                        emit changePage(AllString::selectGamePage);
                    }

                }else{
                    emit requestFailed("Failsed to Process Document");
                }
            }
        }else{
            emit requestFailed(reply->errorString());
            emit changePage(AllString::selectGamePage);
        }
    }else{
        qDebug() << "Hey here";
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

#include "tracinglevel1dataset.h"


TracingLevel1Dataset::TracingLevel1Dataset(AbstractErrorProcessing *parent)
    : AbstractErrorProcessing{parent}
{
    postActivity = new PostActivity(this);
    connect(this, &TracingLevel1Dataset::postRequest, postActivity, &PostActivity::handlePostReqest);
}

/**
 * @brief TracingLevel1Dataset::gatherData
 * @param url this is the endpoint the data will be submitted to
 * @param data This is the data packet that will be submitted
 * @return
 */
void TracingLevel1Dataset::gatherData(const QString &url, const QVariantMap &data)
{

    QByteArray byte;
    QJsonObject jsonObject;
    QUrl urlPost(url);

    // Validate The data Packests
    if(data.isEmpty()){
        // emit  validation Error
    }else{
        QNetworkRequest request(urlPost);

        //Set Headers
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        // request.setRawHeader("Authorization", "Bearer AccessToken");

        // Set and convert Data
        jsonObject["session_id"] = data.value("sessionid").toString();
        jsonObject["userid"] = data.value("userid").toString();
        // jsonObject["dataPacket"] = data.value()
        QJsonDocument doc(jsonObject);
        byte = doc.toJson();
        // The rest does to
        //Trigger the Post
        emit postRequest(byte, request);
    }
    // Serach For empty Data
    //





}


// QString TracingLevel1Dataset::sessionId() const
// {
//     return m_sessionId;
// }

// void TracingLevel1Dataset::setSessionId(const QString &newSessionId)
// {
//     if (m_sessionId == newSessionId)
//         return;
//     m_sessionId = newSessionId;
//     emit sessionIdChanged();
// }

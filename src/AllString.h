#ifndef ALLSTRING_H
#define ALLSTRING_H

#include <QString>
#include <QQmlEngine>
#include <QtQml>
#include <QObject>
#include <QMetaType>



namespace AllString{

Q_NAMESPACE // Required for QML integration
// Q_NAMESPACE_EXPORT(1) // Optional: for dll export

inline const QString appName=QStringLiteral("MVP Dyxi");
inline const QString companyName = QStringLiteral("Orula Deviant");
inline const QString organisationDomain = QStringLiteral("https://dyxi.site");





// Endpoints
const QString baseUrl=QStringLiteral("https://mvp.dyxi.site");
const QString dyxiApiLogin = baseUrl+QStringLiteral("/api/login");
const QString dyxiApiregistration = baseUrl+ QStringLiteral("/api/register");

const QString dyxiApiGetStuentDetails = baseUrl+ QStringLiteral("/api/get-student-details");

// Pages
// all pages should be relative to the Page/SelectPage.qml
// beter still move the SelectPage to the root page
const QString selectGamePage =QStringLiteral("../PageNew/GameCategorySelectPage");

// Session Identifier
const QString activeUserName =QStringLiteral("active_user_name");
const QString activeUserId = QStringLiteral("active_user_id");
const QString activeUserUuid = QStringLiteral("active_user_uuid");
const QString activeUserLanguage = QStringLiteral("active_user_language");

// Q_ENUM_NS(AllString)

}

#endif // ALLSTRING_H

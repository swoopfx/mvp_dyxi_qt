#ifndef ALLSTRING_H
#define ALLSTRING_H

#include <QString>

namespace AllString{
const QString appName=QStringLiteral("MVP Dyxi");
const QString companyName = QStringLiteral("Orula Deviant");
const QString organisationDomain = QStringLiteral("https://dyxi.site");


// Endpoints
const QString baseUrl=QStringLiteral("https://dyxi.site");
const QString dyxiApiLogin = baseUrl+QStringLiteral("/api/login");
const QString dyxiApiregistration = baseUrl+ QStringLiteral("/api/register");

const QString dyxiApiGetStuentDetails = baseUrl+ QStringLiteral("/api/get-student-details");

// Pages
const QString selectGamePage =QStringLiteral("SelectGamePage");

// Session Identifier
const QString activeUserName =QStringLiteral("active_user_name");
const QString activeUserId = QStringLiteral("active_user_id");
const QString activeUserUuid = QStringLiteral("active_user_uuid");
const QString activeUserLanguage = QStringLiteral("active_user_language");
}

#endif // ALLSTRING_H

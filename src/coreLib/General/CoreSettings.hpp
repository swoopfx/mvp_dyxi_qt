#ifndef CORESETTINGS_HPP
#define CORESETTINGS_HPP

#include <QObject>
#include <QQmlEngine>

class CoreSettings : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString myText READ myText WRITE setMyText NOTIFY myTextChanged)

public:
    // explicit MyObject(QObject *parent = nullptr) : QObject(parent)/*, m_myText("Initial Value") {}*/

    // Getter
    QString myText() const { return m_myText; }

    // Setter
    void setMyText(const QString &text) {
        if (m_myText != text) {
            m_myText = text;
            emit myTextChanged(); // Notify QML of the change
        }
    }

signals:
    void myTextChanged();

private:
    QString m_myText;

public:
    explicit CoreSettings(QObject *parent = nullptr) {}
    virtual ~CoreSettings() {}

   static inline const QString appName=QStringLiteral("MVP Dyxi");
    static inline const QString companyName = QStringLiteral("Orula Deviant");
   static inline const QString organisationDomain = QStringLiteral("https://dyxi.site");





    // Endpoints
    static inline const QString baseUrl=QStringLiteral("https://mvp.dyxi.site");
    static inline const QString dyxiApiLogin = baseUrl+QStringLiteral("/api/login");
    static inline const QString dyxiApiregistration = baseUrl+ QStringLiteral("/api/register");

    static inline const QString dyxiApiGetStuentDetails = baseUrl+ QStringLiteral("/api/get-student-details");

    // Pages
    // all pages should be relative to the Page/SelectPage.qml
    // beter still move the SelectPage to the root page
     static inline const QString selectGamePage =QStringLiteral("SelectGameCategoryPage");

    // Session Identifier
     static inline const QString activeUserName =QStringLiteral("active_user_name");
     static inline const QString activeUserId = QStringLiteral("active_user_id");
     static inline const QString activeUserUuid = QStringLiteral("active_user_uuid");
     static inline const QString activeUserLanguage = QStringLiteral("active_user_language");
};

#endif // CORESETTINGS_HPP

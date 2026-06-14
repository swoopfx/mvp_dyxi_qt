import QtQuick 2.15
import QtQuick.Controls

Page {

    id: entryPoint

       // Route passed from the previous page
       property string routeName: ""
       property int typeId: 0
       property int id: 0
    property var stackView

    signal navigate(string page)

       // String -> QML page mapping
       readonly property var pageMap: ({
           "home": "HomePage.qml",
           "settings": "SettingsPage.qml",
           "profile": "ProfilePage.qml",
           "about": "AboutPage.qml",
        "tracing1":"qrc:/modules/modules/Recognition_Shape_Explorer_Level1.qml"


       })



    Component.onCompleted: {
        // navigate(pageMap[routeName])
         console.log("stackView =", stackView)
         Qt.callLater(redirect)
        console.log("EntryPoint")
    }

    function redirect() {
        var target = pageMap[routeName]

        if (!target) {
            console.warn("Unknown route:", routeName)
            target = "NotFoundPage.qml"
        }

        // Push destination while preserving existing stack
        // stackView.view.push(target)
        stackView.replace(target, {
            id: id,
            typeId: typeId
        })

        // Optional: remove this redirect page from the stack
        // StackView.view.pop()
    }



}

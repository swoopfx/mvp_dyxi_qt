import QtQuick 2.15
import QtQuick.Controls

Page {

    id: entryPoint

       // Route passed from the previous page
       property string routeName: ""
       property int typeId: 0
       property int id: 0

       // String -> QML page mapping
       readonly property var pageMap: ({
           "home": "HomePage.qml",
           "settings": "SettingsPage.qml",
           "profile": "ProfilePage.qml",
           "about": "AboutPage.qml"
       })



    Component.onCompleted: {
        redirect()
    }

    function redirect() {
        var target = pageMap[routeName]

        if (!target) {
            console.warn("Unknown route:", routeName)
            target = "NotFoundPage.qml"
        }

        // Push destination while preserving existing stack
        StackView.view.push(target)

        // Optional: remove this redirect page from the stack
        // StackView.view.pop()
    }

       // Loader {
       //     id: pageLoader
       //     anchors.fill: parent
       // }

       // Component.onCompleted: {
       //     redirect()
       // }

       // onRouteNameChanged: {
       //     redirect()
       // }

       // function redirect() {
       //     var targetPage = pageMap[routeName]

       //     if (targetPage !== undefined) {
       //         pageLoader.source = targetPage
       //     } else {
       //         console.warn("Unknown route:", routeName)
       //         pageLoader.source = "NotFoundPage.qml"
       //     }
       // }

}

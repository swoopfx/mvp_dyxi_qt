import QtQuick
import QtQuick.Controls
import UIModule

Window {
    id: main_window
    visible: true
    // width: 640
    // height: 480
    // title: qsTr("Stack")
    visibility: Window.Maximized
    property int screen_maximumHeight: 600
    property int screen_maximumWidth: 1280
    // readonly property real aspectRatio: 4.0/3.0

    // maximumHeight: Screen.desktopAvailaleHeight
    // maximumWidth: Screen.desktopAvailaleWidth

    minimumHeight: main_window.screen_maximumHeight
    minimumWidth: main_window.screen_maximumWidth

    // WelcomePage{}
    StackView {
        id: stackView
         anchors.fill: parent
        initialItem: "qrc:/ui/UIModule/Pages/WelcomePage.qml" // Relative path to the file
    }

}

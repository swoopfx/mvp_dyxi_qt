import QtQuick
import QtQuick.Controls
// import UIModule
import QtQuick.Window


ApplicationWindow {
    id: main_window
    visible: true
    // width: 640
    // height: 480
    // title: qsTr("Stack")
    visibility: Window.Maximized
    property int screen_maximumHeight: 600
    property int screen_maximumWidth: 800
    // readonly property real aspectRatio: 4.0/3.0

    // maximumHeight: Screen.desktopAvailaleHeight
    // maximumWidth: Screen.desktopAvailaleWidth

    minimumHeight: main_window.screen_maximumHeight
    minimumWidth: main_window.screen_maximumWidth

    // Lock app screen orientation to Landscape
       // Screen.orientationUpdateMask: Qt.LandscapeOrientation | Qt.InvertedLandscapeOrientation
       // Screen.contentOrientation: Qt.LandscapeOrientation
       contentOrientation: Qt.LandscapeOrientation


    // WelcomePage{}
    StackView {
        id: stackView
         anchors.fill: parent
        initialItem: "qrc:/ui/UIModule/Pages/WelcomePage.qml" // Relative path to the file
    }
    onClosing: function(closeEvent) {
            if (stackView.depth > 1) {
                // We are deeper in the stack; go back one screen
                stackView.pop();
                closeEvent.accepted = false; // Prevent the app from closing
            } else {
                // We are on the root view; let the app close normally
                closeEvent.accepted = true;
            }
        }

}

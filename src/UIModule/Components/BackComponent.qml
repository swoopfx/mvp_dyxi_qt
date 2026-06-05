import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {

    // Go Back Nav Button in detail page top left
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 16
        width: 80
        height: 36
        radius: 18
        color: backMouse.containsMouse ? window.colorAccent : Qt.rgba(0, 0, 0, 0.6)
        border.color: "white"
        border.width: 1

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }

        RowLayout {
            anchors.centerIn: parent
            spacing: 4
            Text {
                text: "←"
                color: backMouse.containsMouse ? window.colorBg : "white"
                font.pixelSize: 16
                font.bold: true
            }
            Text {
                text: "Back"
                color: backMouse.containsMouse ? window.colorBg : "white"
                font.pixelSize: 12
                font.bold: true
            }
        }

        MouseArea {
            id: backMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: stackView.pop()
        }
    }
}

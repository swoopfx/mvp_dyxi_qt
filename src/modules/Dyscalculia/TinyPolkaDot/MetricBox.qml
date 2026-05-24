import QtQuick
import QtQuick.Layouts

Rectangle {
    property string label: ""
    property var value: ""
    property color color: "black"

    width: 200
    height: 100
    radius: 15
    color: "white"
    border.color: root.color
    border.width: 2

    Column {
        anchors.centerIn: parent
        spacing: 5
        Text {
            text: label
            font.pixelSize: 16
            color: "#666"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            text: value
            font.pixelSize: 28
            font.bold: true
            color: parent.parent.color
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}

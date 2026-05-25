import QtQuick 2.15
import QtQuick.Layouts 1.15

Column {
    property string label: ""
    property var value: 0
    property color color: "black"
    
    Layout.alignment: Qt.AlignCenter
    spacing: 5

    Text {
        text: label
        font.pixelSize: 16
        font.bold: true
        color: "#666"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        text: value
        font.pixelSize: 24
        font.bold: true
        color: parent.color
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

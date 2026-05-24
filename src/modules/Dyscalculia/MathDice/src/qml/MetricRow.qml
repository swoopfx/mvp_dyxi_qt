import QtQuick 2.15
import QtQuick.Layouts 1.15

RowLayout {
    property string label: ""
    property string value: ""
    property color color: "black"

    Text {
        text: label
        font.pixelSize: 16
        Layout.fillWidth: true
    }
    Text {
        text: value
        font.pixelSize: 18
        font.bold: true
        color: parent.color
    }
}

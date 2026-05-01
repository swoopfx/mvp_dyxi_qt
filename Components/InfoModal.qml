
import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: infoPopup
    property alias infoText: infoLabel.text

    width: 300
    height: 200
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    background: Rectangle {
        color: "#ffffff"
        radius: 5
        border.color: "#cccccc"
        border.width: 1
    }

    Column {
        anchors.fill: parent
        padding: 10
        spacing: 10

        Label {
            id: infoLabel
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: 16
            color: "#333333"
        }

        Button {
            text: "Close"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: infoPopup.close()
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: root
    property string itemName: ""
    property string itemDescription: ""

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: 300
    height: 200
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    background: Rectangle {
        color: "white"
        border.color: "black"
        radius: 10
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Label {
            text: itemName
            font.pixelSize: 20
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Label {
            text: itemDescription
            font.pixelSize: 14
            Layout.fillWidth: true
            Layout.fillHeight: true
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Button {
            text: "Close"
            Layout.alignment: Qt.AlignHCenter
            onClicked: root.close()
        }
    }
}

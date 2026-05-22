import QtQuick 2.15

Rectangle {
    id: root
    width: 150; height: 50
    color: "#FF5555"
    radius: 10
    border.color: "white"
    border.width: 2
    
    signal clicked()

    Text {
        anchors.centerIn: parent
        text: "Finish Game"
        color: "white"
        font.bold: true
        font.pixelSize: 18
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: menuRoot
    signal startGame()

    Column {
        anchors.centerIn: parent
        spacing: 30

        Text {
            text: "Phonics Pal"
            font.pixelSize: 64
            font.bold: true
            font.family: "Verdana" // Dyslexia-friendly font
            color: "#333333"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Placeholder for Animated Character
        Rectangle {
            width: 200
            height: 200
            color: "#FFD700"
            radius: 100
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                text: "🤖"
                font.pixelSize: 100
                anchors.centerIn: parent
            }
            
            SequentialAnimation on scale {
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 1.1; duration: 1000; easing.type: Easing.InOutQuad }
                NumberAnimation { from: 1.1; to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
            }
        }

        Button {
            text: "Start Adventure"
            anchors.horizontalCenter: parent.horizontalCenter
            padding: 20
            background: Rectangle {
                color: "#4CAF50"
                radius: 15
            }
            contentItem: Text {
                text: parent.text
                font.pixelSize: 24
                color: "white"
                font.bold: true
            }
            onClicked: menuRoot.startGame()
        }
    }
}

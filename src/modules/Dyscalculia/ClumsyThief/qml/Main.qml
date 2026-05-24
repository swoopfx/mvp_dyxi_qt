import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 1024
    height: 768
    title: "Clumsy Thief - Math Adventure"

    Rectangle {
        anchors.fill: parent
        Image {
            source: "../assets/game_background.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Clumsy Thief"
                font.pixelSize: 64
                color: "#FFD700"
                style: Text.Outline
                styleColor: "black"
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                spacing: 20
                Button {
                    text: "Easy (Sum to 20)"
                    onClicked: gameEngine.startGame(0)
                }
                Button {
                    text: "Hard (Sum to 100)"
                    onClicked: gameEngine.startGame(1)
                }
            }

            Rectangle {
                width: 400
                height: 200
                color: "#80000000"
                radius: 10
                Column {
                    anchors.centerIn: parent
                    spacing: 10
                    Text { text: "Correct: " + gameEngine.metrics[0]; color: "white"; font.pixelSize: 24 }
                    Text { text: "Failed: " + gameEngine.metrics[1]; color: "white"; font.pixelSize: 24 }
                    Text { text: "Accuracy: " + gameEngine.metrics[2].toFixed(1) + "%"; color: "white"; font.pixelSize: 24 }
                }
            }
        }
    }
}

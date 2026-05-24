import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: gameBoard
    anchors.fill: parent

    property var selectedCards: []

    Row {
        id: playerHand
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 50
        spacing: 10

        Repeater {
            model: [10, 20, 30, 40, 50, 60, 70]
            Card {
                value: modelData
                onClicked: {
                    if (selectedCards.length < 2) {
                        selectedCards.push(value)
                        if (selectedCards.length === 2) {
                            gameEngine.attemptMove(selectedCards[0], selectedCards[1])
                            selectedCards = []
                        }
                    }
                }
            }
        }
    }

    Text {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        text: "Target Sum: " + gameEngine.targetSum
        font.pixelSize: 32
        color: "white"
    }
}

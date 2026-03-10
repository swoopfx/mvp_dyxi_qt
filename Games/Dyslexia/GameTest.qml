import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "Component"

Page {
    id: root
    width: 800
    height: 600
    visible: true
    title: "Phonics Pal - Adventure in Sounds"
    // color: "#FFFDD0" // Dyslexia-friendly cream background

    StackView {
        id: mainStack
        anchors.fill: parent
        initialItem: mainMenu
    }

    Component {
        id: mainMenu
        MainMenu {
            onStartGame: mainStack.push(gameLevel, {levelId: 1})
        }
    }

    Component {
        id: gameLevel
        GameLevel {
            onBackToMenu: mainStack.pop()
        }
    }
}

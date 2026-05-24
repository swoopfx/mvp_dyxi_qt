import QtQuick 2.15
import QtQuick.Particles 2.15

Item {
    id: root
    width: 100; height: 100
    property int value: 1
    property color diceColor: "#FFFFFF"

    Rectangle {
        id: diceRect
        anchors.fill: parent
        radius: 15
        color: diceColor
        border.color: "#333"
        border.width: 3
        
        layer.enabled: true
        
        Text {
            anchors.centerIn: parent
            text: value
            font.pixelSize: 40
            font.bold: true
            color: "#2C3E50"
        }

        transform: Rotation {
            id: diceRotation
            origin.x: 50; origin.y: 50; axis { x: 1; y: 1; z: 0 } angle: 0
        }

        states: State {
            name: "rolling"
            PropertyChanges { target: diceRotation; angle: 360 }
        }

        transitions: Transition {
            from: ""; to: "rolling"
            SequentialAnimation {
                NumberAnimation { target: diceRotation; property: "angle"; duration: 500; easing.type: Easing.OutBack }
                PropertyAction { target: root; property: "state"; value: "" }
                PropertyAction { target: diceRotation; property: "angle"; value: 0 }
            }
        }
    }

    function roll() {
        state = "rolling"
    }

    onValueChanged: roll()
}

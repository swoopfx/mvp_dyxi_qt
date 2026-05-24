import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 120
    height: 160
    property int value: 0
    property string colorName: "teal"
    property bool faceUp: false
    property bool matched: false

    signal clicked()

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: root.faceUp ? "white" : "#FFD700"
        border.color: "#DAA520"
        border.width: 2

        // Card Back Pattern
        Rectangle {
            anchors.fill: parent
            anchors.margins: 10
            visible: !root.faceUp
            color: "transparent"
            border.color: "white"
            border.width: 1
            radius: 5
            
            Text {
                anchors.centerIn: parent
                text: "?"
                font.pixelSize: 40
                color: "white"
            }
        }

        // Card Front (Dots)
        Grid {
            id: dotGrid
            anchors.centerIn: parent
            columns: 3
            spacing: 10
            visible: root.faceUp

            Repeater {
                model: root.value
                Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    color: root.colorName
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }

    states: [
        State {
            name: "matched"
            when: root.matched
            PropertyChanges { target: root; opacity: 0; scale: 0.5 }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity,scale"; duration: 500; easing.type: Easing.OutQuad }
    }
}

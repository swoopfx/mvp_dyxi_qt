import QtQuick 2.15

Item {
    id: root
    width: 150
    height: 200
    property int value: 10
    property string imageSource: "../assets/money_card_10.png"
    property bool faceUp: true

    Rectangle {
        anchors.fill: parent
        radius: 10
        clip: true
        border.color: "white"
        border.width: 2

        Image {
            anchors.fill: parent
            source: faceUp ? imageSource : "../assets/card_back.png"
            fillMode: Image.PreserveAspectFit
        }

        Behavior on scale { NumberAnimation { duration: 200 } }
        
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.scale = 1.1
            onExited: root.scale = 1.0
            onClicked: {
                // Logic for selecting card
            }
        }
    }
}

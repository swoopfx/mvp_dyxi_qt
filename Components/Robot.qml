import QtQuick 2.15

Item {
    id: robot
    width: 200
    height: 300
    
    property color bodyColor: "#90EE90"
    property bool isMoving: true

    // Animation for floating movement
    SequentialAnimation on y {
        running: robot.isMoving
        loops: Animation.Infinite
        NumberAnimation { from: 100; to: 120; duration: 2000; easing.type: Easing.InOutQuad }
        NumberAnimation { from: 120; to: 100; duration: 2000; easing.type: Easing.InOutQuad }
    }

    // Head
    Image {
        id: head
        source: "qrc:/img/images/robot_head.svg"
        width: 60
        height: 60
        anchors.horizontalCenter: body.horizontalCenter
        anchors.bottom: body.top
        anchors.bottomMargin: -10
        z: 2
    }

    // Body
    Rectangle {
        id: body
        width: 80
        height: 120
        color: robot.bodyColor
        radius: 20
        border.color: "black"
        border.width: 2
        anchors.centerIn: parent
        z: 1

        // Joint markers
        Rectangle { x: 10; y: 15; width: 10; height: 10; radius: 5; color: "#77DD77"; border.color: "black" }
        Rectangle { x: 60; y: 15; width: 10; height: 10; radius: 5; color: "#77DD77"; border.color: "black" }
        Rectangle { x: 10; y: 95; width: 10; height: 10; radius: 5; color: "#77DD77"; border.color: "black" }
        Rectangle { x: 60; y: 95; width: 10; height: 10; radius: 5; color: "#77DD77"; border.color: "black" }
        SequentialAnimation on rotation {
            loops: Animation.Infinite
            NumberAnimation { from: -30; to: -50; duration: 1500; easing.type: Easing.InOutQuad }
            NumberAnimation { from: -50; to: -30; duration: 1500; easing.type: Easing.InOutQuad }
        }
    }

    // Arms
    Image {
        id: leftArm
        source: "qrc:/img/images/robot_limb.svg"
        width: 15
        height: 80
        x: body.x - 5
        y: body.y + 10
        rotation: -30
        transformOrigin: Item.Top
        z: 0
        SequentialAnimation on rotation {
            loops: Animation.Infinite
            NumberAnimation { from: -30; to: -50; duration: 1500; easing.type: Easing.InOutQuad }
            NumberAnimation { from: -50; to: -30; duration: 1500; easing.type: Easing.InOutQuad }
        }
    }

    Image {
        id: rightArm
        source: "qrc:/img/images/robot_limb.svg"
        width: 15
        height: 80
        x: body.x + body.width - 10
        y: body.y + 10
        rotation: 30
        transformOrigin: Item.Top
        z: 0
        SequentialAnimation on rotation {
            loops: Animation.Infinite
            NumberAnimation { from: 30; to: 50; duration: 1500; easing.type: Easing.InOutQuad }
            NumberAnimation { from: 50; to: 30; duration: 1500; easing.type: Easing.InOutQuad }
        }
    }

    // Legs
    Image {
        id: leftLeg
        source: "../assets/robot_limb.svg"
        width: 15
        height: 80
        x: body.x + 15
        y: body.y + body.height - 10
        rotation: 20
        transformOrigin: Item.Top
        z: 0
        SequentialAnimation on rotation {
            loops: Animation.Infinite
            NumberAnimation { from: 20; to: 40; duration: 1800; easing.type: Easing.InOutQuad }
            NumberAnimation { from: 40; to: 20; duration: 1800; easing.type: Easing.InOutQuad }
        }
    }

    Image {
        id: rightLeg
        source: "qrc:/img/images/robot_limb.svg"
        width: 15
        height: 80
        x: body.x + body.width - 30
        y: body.y + body.height - 10
        z: 100
        rotation: -20
        transformOrigin: Item.Top
        // z: 0
        SequentialAnimation on rotation {
            loops: Animation.Infinite
            NumberAnimation { from: -20; to: -40; duration: 1800; easing.type: Easing.InOutQuad }
            NumberAnimation { from: -40; to: -20; duration: 1800; easing.type: Easing.InOutQuad }
        }
    }

    function changeColor(newColor) {
        bodyColor = newColor
    }

    // Drop area for painting
    DropArea {
        anchors.fill: body
        onEntered: {
            body.border.color = "white"
            body.border.width = 4
        }
        onExited: {
            body.border.color = "black"
            body.border.width = 2
        }
        onDropped: (drop) => {
            if (drop.hasColor) {
                changeColor(drop.colorData)
                drop.accept()
                body.border.color = "black"
                body.border.width = 2
            }
        }
    }
}

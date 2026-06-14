import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: 130
    height: 72

    property string shapeType: ""
    property string shapeName: ""
    property string shapeGlyph: ""
    property color baseColor: "lightblue"
    property color gradientTo: "blue"

    property real targetX: 0
    property real targetY: 0
    property bool isMatched: false
    property real tolerance: 85.0

    property real startTime: 0

    signal matched(real duration)
    signal failed(real duration)

    // Inner customized visual shape styling with gorgeous 3D projection illusion
    Rectangle {
        id: body
        anchors.fill: parent
        radius: 12
        gradient: Gradient {
            GradientStop { position: 0.0; color: baseColor }
            GradientStop { position: 1.0; color: gradientTo }
        }
        border.color: "#FFFFFF"
        border.width: 2.0

        // Embossed 3D feeling top highlight
        Rectangle {
            width: parent.width - 6
            height: parent.height / 2 - 3
            radius: 9
            color: "#40FFFFFF"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 3
        }

        // Inner Glyphs and text labels
        Row {
            anchors.centerIn: parent
            spacing: 8
            Text {
                text: shapeGlyph
                font.pixelSize: 22
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: shapeName
                color: "white"
                font.bold: true
                font.pixelSize: 11
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Shadow element directly underneath for true 3D suspension
        Rectangle {
            id: shadow
            width: parent.width - 15
            height: 6
            radius: 3
            color: "#60000000"
            anchors.top: parent.bottom
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: dragArea.drag.active ? 0.3 : 0.75
            scale: dragArea.drag.active ? 0.8 : 1.0

            Behavior on scale { NumberAnimation { duration: 150 } }
        }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: root
        drag.axis: Drag.XAndYAxis

        onPressed: {
            if (isMatched) return;
            root.startTime = new Date().getTime()
            body.scale = 1.15
            body.z = 100
        }

        onReleased: {
            if (isMatched) return;
            body.scale = 1.0
            body.z = 1
            var duration = new Date().getTime() - root.startTime

            // Verify proximity to designated target coordinates
            var globalX = root.x
            var globalY = root.y
            var distance = Math.sqrt(Math.pow(globalX - targetX, 2) + Math.pow(globalY - targetY, 2))

            if (distance < root.tolerance) {
                isMatched = true
                root.x = targetX
                root.y = targetY
                root.matched(duration)
                body.border.color = "#10B981"
            } else {
                bounceBackAnimation.start()
                root.failed(duration)
            }
        }
    }

    ParallelAnimation {
        id: bounceBackAnimation
        NumberAnimation { target: root; property: "x"; to: 0; duration: 250; easing.type: Easing.OutBounce }
        NumberAnimation { target: root; property: "y"; to: 0; duration: 250; easing.type: Easing.OutBounce }
    }
}

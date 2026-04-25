import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "../Components"


Page {
    id: root
    width: 800
    height: 800
    visible: true
    title: qsTr("Drag and Drop Robot - Motor Skills & ADHD/Dyslexia Metrics")
    // color: "#E6C9A8" // Background color from design

    property var metricsLog: []
    property var currentMetrics: ({})

    // Robot in the middle
    Robot {
        id: robot
        anchors.centerIn: parent
        z: 1
    }

    // Color circles surrounding the robot
    Repeater {
        model: [
            { color: "#8B4513", angle: 0 },   // Brown
            { color: "#BC8F8F", angle: 36 },  // Rosy Brown
            { color: "#FF69B4", angle: 72 },  // Hot Pink
            { color: "#5F9EA0", angle: 108 }, // Cadet Blue
            { color: "#90EE90", angle: 144 }, // Light Green
            { color: "#FFFF00", angle: 180 }, // Yellow
            { color: "#FFDAB9", angle: 216 }, // Peach Puff
            { color: "#DA70D6", angle: 252 }, // Orchid
            { color: "#9ACD32", angle: 288 }, // Yellow Green
            { color: "#4B0082", angle: 324 }  // Indigo
        ]

        ColorCircle {
            property real angleRad: modelData.angle * Math.PI / 180
            property real radius: 300

            x: root.width / 2 + radius * Math.cos(angleRad) - width / 2
            y: root.height / 2 + radius * Math.sin(angleRad) - height / 2
            color: modelData.color
            initialPos: Qt.point(x, y)

            onDroppedOnRobot: (colorData, metrics) => {
                // Check if dropped on robot body
                let robotX = robot.x + robot.width / 2 - 40 // body center x
                let robotY = robot.y + robot.height / 2 - 60 // body center y
                let dist = Math.sqrt(Math.pow(metrics.endX - robotX, 2) + Math.pow(metrics.endY - robotY, 2))

                if (dist < 100) { // Success threshold
                    robot.changeColor(colorData)
                    metrics.success = true
                } else {
                    metrics.success = false
                }

                // Add additional metrics for ADHD/Dyslexia
                metrics.reactionTime = metrics.duration // simplified for this demo
                metrics.impulsivity = metrics.pathLength < 10 ? 1 : 0 // short, quick movements
                metrics.directionalBias = metrics.endX > metrics.startX ? "Right" : "Left"

                root.currentMetrics = metrics
                root.metricsLog.push(metrics)
                metricsDisplay.visible = true
            }
        }
    }

    // Metrics Display Panel
    Rectangle {
        id: metricsDisplay
        width: 300
        height: 400
        color: "white"
        opacity: 0.9
        border.color: "black"
        border.width: 1
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        visible: false
        radius: 10

        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            Text { text: "<b>Game Metrics</b>"; font.pixelSize: 18; anchors.horizontalCenter: parent.horizontalCenter }

            Text { text: "<b>Motor Skills:</b>"; font.bold: true }
            Text { text: "Success: " + (root.currentMetrics.success ? "YES" : "NO") }
            Text { text: "Path Efficiency: " + (root.currentMetrics.efficiency ? root.currentMetrics.efficiency.toFixed(2) : "0.00") }
            Text { text: "Duration: " + (root.currentMetrics.duration ? root.currentMetrics.duration.toFixed(2) : "0.00") + "s" }

            Text { text: "<b>ADHD Indicators:</b>"; font.bold: true }
            Text { text: "Impulsivity: " + (root.currentMetrics.impulsivity ? "High" : "Normal") }
            Text { text: "Reaction Time: " + (root.currentMetrics.reactionTime ? root.currentMetrics.reactionTime.toFixed(2) : "0.00") + "s" }

            Text { text: "<b>Dyslexia Indicators:</b>"; font.bold: true }
            Text { text: "Directional Bias: " + (root.currentMetrics.directionalBias || "None") }
            Text { text: "Spatial Accuracy: " + (root.currentMetrics.success ? "High" : "Low") }

            Button {
                text: "Close"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: metricsDisplay.visible = false
            }
        }
    }

    Text {
        text: "Drag colors to the robot to paint it!"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 20
        font.pixelSize: 20
        color: "#5D4037"
    }
}

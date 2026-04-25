import QtQuick 2.15

Rectangle {
    id: colorCircle
    width: 50
    height: 50
    radius: width / 2
    color: "red"
    border.color: "black"
    border.width: 2

    property point initialPos: Qt.point(x, y)
    property var startTime: 0
    property var dragPath: []
    property bool isDragging: false

    signal droppedOnRobot(color colorData, var metrics)

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: parent
        
        onPressed: {
            colorCircle.z = 100
            colorCircle.startTime = Date.now()
            colorCircle.dragPath = [Qt.point(colorCircle.x, colorCircle.y)]
            colorCircle.isDragging = true
        }

        onPositionChanged: {
            if (colorCircle.isDragging) {
                colorCircle.dragPath.push(Qt.point(colorCircle.x, colorCircle.y))
            }
        }

        onReleased: {
            colorCircle.z = 0
            colorCircle.isDragging = false
            
            // Calculate metrics
            let endTime = Date.now()
            let duration = (endTime - colorCircle.startTime) / 1000 // seconds
            
            let pathLength = 0
            for (let i = 1; i < colorCircle.dragPath.length; i++) {
                let p1 = colorCircle.dragPath[i-1]
                let p2 = colorCircle.dragPath[i]
                pathLength += Math.sqrt(Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2))
            }
            
            let straightLine = Math.sqrt(Math.pow(colorCircle.x - colorCircle.initialPos.x, 2) + 
                                         Math.pow(colorCircle.y - colorCircle.initialPos.y, 2))
            
            let efficiency = straightLine > 0 ? straightLine / pathLength : 0
            
            let metrics = {
                "duration": duration,
                "pathLength": pathLength,
                "efficiency": efficiency,
                "startX": colorCircle.initialPos.x,
                "startY": colorCircle.initialPos.y,
                "endX": colorCircle.x,
                "endY": colorCircle.y
            }

            // Check if dropped on robot (handled by main.qml or Robot.qml DropArea)
            // For simplicity, we'll let main.qml handle the drop detection
            colorCircle.droppedOnRobot(colorCircle.color, metrics)
            
            // Return to initial position
            x = colorCircle.initialPos.x
            y = colorCircle.initialPos.y
        }
    }

    // Shadow effect
    Rectangle {
        anchors.fill: parent
        anchors.margins: -2
        radius: parent.radius
        color: "black"
        opacity: 0.2
        z: -1
        visible: !colorCircle.isDragging
    }
}

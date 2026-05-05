import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Item {
    id: window
    visible: true
    anchors.fill: parent
    // title: "Touch Telemetry Capture"

    property var touchData: []
    property real startTime: 0
    property real lastTouchX: 0
    property real lastTouchY: 0
    property bool timerStarted: false
    property var currentPath: []
    property bool isDrawing: false
    property string selectedColor: "#4ecdc4"

    property int brushSize: 20

    Rectangle {
        id: canvasArea
        anchors.fill: parent
        color: "transparent"

        // Canvas for drawing
        Canvas {
            id: canvas
            anchors.fill: parent
            antialiasing: true

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                // Draw all recorded paths
                for (var i = 0; i < window.touchData.length; i++) {
                    var pathData = window.touchData[i].position
                    if (pathData.length > 0) {
                        ctx.strokeStyle = pathData[0].color
                        ctx.lineWidth = window.brushSize
                        ctx.lineCap = "round"
                        ctx.lineJoin = "round"
                        ctx.beginPath()

                        ctx.moveTo(pathData[0].x, pathData[0].y)
                        for (var j = 1; j < pathData.length; j++) {
                            ctx.lineTo(pathData[j].x, pathData[j].y)
                        }
                        ctx.stroke()
                    }
                }
            }
        }

        // Touch handling (unchanged)
        MultiPointTouchArea {
            anchors.fill: parent
            touchPoints: [
                TouchPoint { id: touchPoint1 }
            ]

            onPressed: {
                if (!window.timerStarted) {
                    window.startTime = new Date().getTime()
                    window.timerStarted = true
                }

                window.isDrawing = true
                window.currentPath = []
                var touch = touchPoints[0]
                window.lastTouchX = touch.x
                window.lastTouchY = touch.y

                window.currentPath.push({
                    x: touch.x,
                    y: touch.y,
                    timestamp: new Date().getTime() - window.startTime,
                    color: window.selectedColor,
                    pressure: touch.pressure || 1.0
                })
            }

            onUpdated: {
                if (window.isDrawing && touchPoints.length > 0) {
                    var touch = touchPoints[0]
                    var now = new Date().getTime()
                    var elapsed = now - window.startTime

                    var dx = touch.x - window.lastTouchX
                    var dy = touch.y - window.lastTouchY
                    var distance = Math.sqrt(dx*dx + dy*dy)
                    var angle = Math.atan2(dy, dx) * 180 / Math.PI
                    if (angle < 0) angle += 360

                    window.currentPath.push({
                        x: touch.x,
                        y: touch.y,
                        timestamp: elapsed,
                        distance: distance,
                        direction: angle,
                        color: window.selectedColor,
                        pressure: touch.pressure || 1.0
                    })

                    window.lastTouchX = touch.x
                    window.lastTouchY = touch.y
                    canvas.requestPaint()
                }
            }

            onReleased: {
                if (window.currentPath.length > 0) {
                    var totalTouchDuration = window.currentPath[window.currentPath.length-1].timestamp -
                                           window.currentPath[0].timestamp
                    var avgSpeed = 0
                    var totalDistance = 0

                    for (var i = 1; i < window.currentPath.length; i++) {
                        totalDistance += window.currentPath[i].distance || 0
                    }
                    avgSpeed = totalDistance / (totalTouchDuration / 1000)

                    window.touchData.push({
                        position: window.currentPath.slice(),
                        time_frequency: {
                            start_time: window.currentPath[0].timestamp,
                            end_time: window.currentPath[window.currentPath.length-1].timestamp,
                            duration: totalTouchDuration,
                            avg_speed: avgSpeed,
                            total_distance: totalDistance,
                            point_count: window.currentPath.length
                        },
                        touch_frequency: {
                            pressure_avg: window.currentPath.reduce((sum, p) => sum + (p.pressure || 1), 0) / window.currentPath.length,
                            direction_variance: calculateDirectionVariance(window.currentPath)
                        }
                    })

                    window.currentPath = []
                    window.isDrawing = false
                    canvas.requestPaint()
                }
            }
        }

        // Color palette
        Row {
            id: colorPalette
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 20
            spacing: 10

            Repeater {
                model: ["#ff6b6b", "#4ecdc4", "#45b7d1", "#f9ca24"]
                Rectangle {
                    width: 40
                    height: 40
                    radius: 20
                    color: modelData
                    border.color: window.selectedColor === modelData ? "#fff" : "#000"
                    border.width: 3

                    MouseArea {
                        anchors.fill: parent
                        onClicked: window.selectedColor = modelData
                    }
                }
            }
        }

        // Stats display
        Column {
            id: statsColumn
            anchors.top: colorPalette.bottom
            anchors.left: colorPalette.left
            anchors.topMargin: 20
            spacing: 5

            Text {
                id: touchCountText
                text: "Touches: " + window.touchData.length
                color: "white"
                font.pixelSize: 16
                font.bold: true
            }
            Text {
                id: totalTimeText
                text: "Total Time: " + (window.timerStarted ? Math.round((new Date().getTime() - window.startTime)/1000) + "s" : "0s")
                color: "white"
                font.pixelSize: 14
            }
        }

        // Control buttons
        Row {
            id: controlButtons
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 20
            spacing: 15

            // CLEAR BUTTON - NEW
            Button {
                id: clearButton
                text: "🗑️ Clear"
                width: 100
                height: 50
                font.pixelSize: 14
                font.bold: true

                background: Rectangle {
                    radius: 25
                    color: "#e74c3c"
                    border.color: "#c0392b"
                    border.width: 2
                }

                onClicked: {
                    // Clear all drawings and telemetry data
                    window.touchData = []
                    window.currentPath = []
                    window.isDrawing = false
                    canvas.requestPaint()

                    // Update stats
                    touchCountText.text = "Touches: 0"
                }
            }

            // Submit button
            Button {
                id: submitButton
                text: "Submit Data"
                width: 120
                height: 50
                font.pixelSize: 16
                font.bold: true

                background: Rectangle {
                    radius: 25
                    color: "#3498db"
                    border.color: "#2980b9"
                    border.width: 2
                }

                onClicked: {
                    var finalData = {
                        telemetry_session: {
                            start_time: window.startTime,
                            end_time: new Date().getTime(),
                            total_duration: new Date().getTime() - window.startTime,
                            total_touches: window.touchData.length,
                            canvas_size: { width: canvas.width, height: canvas.height }
                        },
                        touches: window.touchData
                    }

                    console.log(JSON.stringify(finalData, null, 2))
                }
            }
        }
    }

    function calculateDirectionVariance(path) {
        if (path.length < 2) return 0
        var directions = path.slice(1).map(p => p.direction || 0)
        var avg = directions.reduce((a, b) => a + b) / directions.length
        var variance = directions.reduce((sum, dir) => sum + Math.pow(dir - avg, 2), 0) / directions.length
        return Math.sqrt(variance)
    }

    Component.onCompleted: {
        startTime = new Date().getTime()
        timerStarted = true
    }
}
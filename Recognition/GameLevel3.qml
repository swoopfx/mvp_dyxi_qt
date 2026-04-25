import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: level3
    
    property string targetChar: "A"
    property int score: 0
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 30

        RowLayout {
            Layout.fillWidth: true
            Button {
                text: "Back"
                onClicked: stackView.pop()
                font.family: dyslexiaFont.name
                font.pixelSize: 20
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "Score: " + score
                font.family: dyslexiaFont.name
                font.pixelSize: 30
                color: "#4A4A4A"
            }
        }

        Text {
            text: "Trace the letter!"
            font.family: dyslexiaFont.name
            font.pixelSize: 40
            color: "#4A4A4A"
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            id: canvasContainer
            Layout.preferredWidth: 400
            Layout.preferredHeight: 400
            Layout.alignment: Qt.AlignHCenter
            color: "#FFFACD" // Light lemon chiffon
            radius: 20
            border.width: 5
            border.color: "#98FB98"
            
            Text {
                id: ghostText
                anchors.centerIn: parent
                text: targetChar
                font.family: dyslexiaFont.name
                font.pixelSize: 300
                color: "rgba(74, 74, 74, 0.2)" // Faint for tracing
            }

            Canvas {
                id: drawingCanvas
                anchors.fill: parent
                property var points: []
                
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.strokeStyle = "#4A4A4A"
                    ctx.lineWidth = 15
                    ctx.lineCap = "round"
                    ctx.lineJoin = "round"
                    
                    if (points.length < 2) return
                    
                    ctx.beginPath()
                    ctx.moveTo(points[0].x, points[0].y)
                    for (var i = 1; i < points.length; i++) {
                        ctx.lineTo(points[i].x, points[i].y)
                    }
                    ctx.stroke()
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: (mouse) => {
                        drawingCanvas.points = [{x: mouse.x, y: mouse.y}]
                        drawingCanvas.requestPaint()
                    }
                    onPositionChanged: (mouse) => {
                        drawingCanvas.points.push({x: mouse.x, y: mouse.y})
                        drawingCanvas.requestPaint()
                    }
                    onReleased: {
                        // In a real game, we'd check if the shape matches the letter
                        // For now, let's just reward completion
                        score += 20
                        confirmTimer.start()
                    }
                }
            }
            
            Timer {
                id: confirmTimer
                interval: 1000
                onTriggered: {
                    drawingCanvas.points = []
                    drawingCanvas.requestPaint()
                    generateNewChallenge()
                }
            }
        }

        Button {
            text: "Clear"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                drawingCanvas.points = []
                drawingCanvas.requestPaint()
            }
        }
    }
    
    function generateNewChallenge() {
        var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        targetChar = alphabet.charAt(Math.floor(Math.random() * alphabet.length))
    }
    
    Component.onCompleted: generateNewChallenge()
}

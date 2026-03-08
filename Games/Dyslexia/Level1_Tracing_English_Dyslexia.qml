import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Particles 2.15

Page {
    visible: true
    width: 900
    height: 600
    title: "Alphabet Tracing Game"

    property string currentLetter: "A"
    property int tracedPoints: 0

    Rectangle {
        anchors.fill: parent
        color: "#FFF7D6"

        Column {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Trace the Letter"
                font.pixelSize: 40
                color: "#444"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: currentLetter
                font.pixelSize: 200
                color: "#D3D3D3"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                id: traceArea
                width: 500
                height: 300
                radius: 20
                color: "white"
                border.color: "#FF9800"
                border.width: 6

                Canvas {
                    id: drawingCanvas
                    anchors.fill: parent

                    property var points: []

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.lineWidth = 10
                        ctx.lineCap = "round"
                        ctx.strokeStyle = "#4CAF50"

                        ctx.beginPath()

                        for (var i = 0; i < points.length; i++) {
                            var p = points[i]
                            if (i === 0)
                                ctx.moveTo(p.x, p.y)
                            else
                                ctx.lineTo(p.x, p.y)
                        }

                        ctx.stroke()
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    onPressed: {
                        drawingCanvas.points = []
                    }

                    onPositionChanged: {
                        drawingCanvas.points.push({"x": mouse.x, "y": mouse.y})
                        drawingCanvas.requestPaint()

                        tracedPoints++

                        if (tracedPoints > 120) {
                            successAnimation.start()
                        }
                    }

                    onReleased: {
                        tracedPoints = 0
                    }
                }
            }
        }

        // CONFETTI CELEBRATION
        ParticleSystem {
            id: particles
        }

        Emitter {
            id: successAnimation
            system: particles
            anchors.top: parent.top
            width: parent.width
            emitRate: 200
            lifeSpan: 2000
            velocity: AngleDirection { angle: 270; magnitude: 200 }
            size: 8
            enabled: false

            Timer {
                interval: 2000
                running: successAnimation.enabled
                onTriggered: successAnimation.enabled = false
            }

            onEnabledChanged: {
                if(enabled)
                    celebrationText.visible = true
            }
        }

        ImageParticle {
            system: particles
            source: "qrc:/confetti.png"
        }

        Text {
            id: celebrationText
            text: "🎉 Great Job!"
            font.pixelSize: 50
            color: "#FF4081"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 50
            visible: false
        }
    }
}

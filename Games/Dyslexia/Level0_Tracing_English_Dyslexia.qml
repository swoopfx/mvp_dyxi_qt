import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Particles 2.15

Page {
    visible: true
    // width: 900
    // height: 650
    // title: "Alphabet Tracing"

    property int currentPoint: 0
    property int successCount: guidePoints.length

    // Guide points representing letter A path
    property var guidePoints: [
        {x:200,y:450},
        {x:300,y:200},
        {x:400,y:450},
        {x:350,y:350},
        {x:250,y:350}
    ]

    Rectangle {
        anchors.fill: parent
        color: "#FFF9C4"

        Text {
            text: "Trace the Letter A"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 40
            color: "#333"
            topPadding: 20
        }

        // Big background letter
        Text {
            text: "A"
            font.pixelSize: 260
            color: "#E0E0E0"
            anchors.centerIn: parent
        }

        Canvas {
            id: traceCanvas
            anchors.fill: parent
            property var points: []

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0,0,width,height)

                ctx.lineWidth = 12
                ctx.strokeStyle = "#4CAF50"
                ctx.lineCap = "round"

                ctx.beginPath()

                for (var i=0;i<points.length;i++){
                    var p = points[i]
                    if(i===0)
                        ctx.moveTo(p.x,p.y)
                    else
                        ctx.lineTo(p.x,p.y)
                }

                ctx.stroke()
            }
        }

        // GUIDE DOTS
        Repeater {
            model: guidePoints

            Rectangle {
                width: 30
                height: 30
                radius: 15

                x: modelData.x
                y: modelData.y

                color: index === currentPoint ? "#FF5722" : "#90CAF9"

                border.color: "white"
                border.width: 3

                Behavior on scale {
                    NumberAnimation { duration: 200 }
                }

                scale: index === currentPoint ? 1.4 : 1
            }
        }

        MouseArea {
            anchors.fill: parent

            onPositionChanged: {

                traceCanvas.points.push({"x":mouse.x,"y":mouse.y})
                traceCanvas.requestPaint()

                if(currentPoint < guidePoints.length){

                    var gp = guidePoints[currentPoint]

                    var dx = mouse.x - gp.x
                    var dy = mouse.y - gp.y
                    var dist = Math.sqrt(dx*dx + dy*dy)

                    if(dist < 40){
                        currentPoint++

                        if(currentPoint === guidePoints.length){
                            celebrationEmitter.enabled = true
                            successText.visible = true
                        }
                    }
                }
            }

            onPressed: {
                traceCanvas.points = []
            }
        }

        // CONFETTI PARTICLES
        ParticleSystem { id: particles }

        Emitter {
            id: celebrationEmitter
            system: particles
            anchors.top: parent.top
            width: parent.width
            emitRate: 300
            lifeSpan: 2000
            velocity: AngleDirection { angle: 270; magnitude: 250 }
            size: 8
            enabled: false
        }

        ImageParticle {
            system: particles
            source: "qrc:/confetti.png"
        }

        Text {
            id: successText
            text: "🎉 Excellent!"
            font.pixelSize: 50
            color: "#E91E63"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 80
            visible: false
        }
    }
}

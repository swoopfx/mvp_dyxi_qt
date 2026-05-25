import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "Component"

Item {

    id: tracingLetter
    anchors.fill: parent

    Rectangle{
        id: background
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#e0f7fa" }
            GradientStop { position: 1.0; color: "#80deea" }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 20
            anchors.margins: 40

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Word Recognition Fun!"
                font.pixelSize: 48
                font.bold: true
                color: "#00796b"
                style: Text.Outline
                styleColor: "white"
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 50

                // Left: Word Display
                Rectangle {
                    id: leftRectangle
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "white"
                    radius: 30
                    border.color: "#4db6ac"
                    border.width: 5

                    // Text {
                    //     id: wordText
                    //     anchors.centerIn: parent
                    //     // text: gameEngine.currentWord
                    //     font.pixelSize: 120
                    //     font.bold: true
                    //     color: "#ff5722"
                    //     style: Text.Raised
                    //     styleColor: "#bf360c"

                    //     // Behavior on text {
                    //     //     SequentialAnimation {
                    //     //         NumberAnimation { target: wordText; property: "scale"; from: 1.0; to: 1.2; duration: 200 }
                    //     //         NumberAnimation { target: wordText; property: "scale"; from: 1.2; to: 1.0; duration: 200 }
                    //     //     }
                    //     // }



                    // }


                    Tracer{
                        letter: "A"
                        size: leftRectangle.height - 20

                    }
                    Canvas {
                           id: traceableCanvas
                           anchors.fill: parent

                           // Define paths for the letters (Example: Letter 'A')
                           onPaint: {
                               var ctx = getContext("2d")
                               // ctx.reset()

                               // 1. Traceable (Dashed) Letter Background
                               ctx.strokeStyle = "lightgray"
                               ctx.lineWidth = leftRectangle.height/9
                               ctx.lineCap = "round"
                               ctx.lineJoin = "round"
                               ctx.setLineDash([5, 10]) // Creates the dotted/traceable effect

                               ctx.beginPath()
                               // Draw an 'A'
                               // ctx.moveTo(150, 50)
                               // ctx.lineTo(50, 300)
                               // ctx.moveTo(150, 50)
                               // ctx.lineTo(250, 300)
                               // ctx.moveTo(90, 200)
                               // ctx.lineTo(210, 200)
                               // ctx.stroke()

                               // 2. User's Drawing (Solid Line)
                               ctx.strokeStyle = "blue"
                               ctx.setLineDash([]) // Solid line for tracing
                               ctx.beginPath()
                               // Connect the points as the user drags
                               for (var i = 0; i < points.length; i++) {
                                   if (i === 0) {
                                       ctx.moveTo(points[i].x, points[i].y)
                                   } else {
                                       ctx.lineTo(points[i].x, points[i].y)
                                   }
                               }
                               ctx.stroke()
                           }

                           // Store the touch/mouse points
                           property var points: []

                           MouseArea {
                               anchors.fill: parent
                               onPressed: {
                                   traceableCanvas.points = [{x: mouse.x, y: mouse.y}]
                                   traceableCanvas.requestPaint()
                               }
                               onPositionChanged: {
                                   traceableCanvas.points.push({x: mouse.x, y: mouse.y})
                                   traceableCanvas.requestPaint()
                               }
                           }
                       }
                }

                // Right: Image Display
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "white"
                    radius: 30
                    border.color: "#4db6ac"
                    border.width: 5
                    clip: true



                    Text {
                        id: actualLetter
                        anchors.centerIn: parent
                        // text: gameEngine.currentWord
                        text: "A"
                        font.pixelSize: leftRectangle.height - 20
                        font.bold: true
                        color: "#ff5722"
                        style: Text.Raised
                        styleColor: "#bf360c"

                        // Behavior on text {
                        //     SequentialAnimation {
                        //         NumberAnimation { target: wordText; property: "scale"; from: 1.0; to: 1.2; duration: 200 }
                        //         NumberAnimation { target: wordText; property: "scale"; from: 1.2; to: 1.0; duration: 200 }
                        //     }
                        // }



                    }

                    // Image {
                    //     id: wordImage
                    //     anchors.fill: parent
                    //     anchors.margins: 20
                    //     // source: gameEngine.currentImage
                    //     fillMode: Image.PreserveAspectFit

                    //     Behavior on source {
                    //         NumberAnimation { target: wordImage; property: "opacity"; from: 0; to: 1; duration: 500 }
                    //     }
                    // }
                }
            }

            // Recording Status
            // Rectangle {
            //     Layout.alignment: Qt.AlignHCenter
            //     width: 200
            //     height: 60
            //     color: gameEngine.isRecording ? "#ff1744" : "#cfd8dc"
            //     radius: 30

            //     Text {
            //         anchors.centerIn: parent
            //         text: gameEngine.isRecording ? "Listening..." : "Waiting"
            //         color: "white"
            //         font.pixelSize: 24
            //         font.bold: true
            //     }

            //     SequentialAnimation on opacity {
            //         running: gameEngine.isRecording
            //         loops: Animation.Infinite
            //         NumberAnimation { from: 1.0; to: 0.5; duration: 500 }
            //         NumberAnimation { from: 0.5; to: 1.0; duration: 500 }
            //     }
            // }
        }

    }

}


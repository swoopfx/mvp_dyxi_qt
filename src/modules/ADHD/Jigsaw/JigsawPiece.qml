import QtQuick 6.5
import QtQuick.Effects

Item {
    id: rootPiece

    property int pieceId: 0
    property int correctRow: 0
    property int correctCol: 0
    property real cellSize: 120
    property string shapeStyle: "jigsaw" // "jigsaw", "square", "triangle", "circle"
    property string imageUrl: "qrc:/assets/koala.png"
    property var engineBridge

    width: cellSize
    height: cellSize

    // Interactive Drag Handler
    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: parent
        drag.smoothed: true

        onPressed: {
            rootPiece.parent = rootPiece.window.contentItem;
            engineBridge.logDragEntropy(0.0, mouseX, mouseY); // log initial focus point in C++
        }

        onReleased: {
            // Evaluates snap coordinates
            var gridSlot = findNearestSlot(rootPiece.x, rootPiece.y);
            if (gridSlot.row === rootPiece.correctRow && gridSlot.col === rootPiece.correctCol) {
                rootPiece.x = gridSlot.targetX;
                rootPiece.y = gridSlot.targetY;
                rootPiece.enabled = false; // lock down
                engineBridge.dispatchTelemetry(rootPiece.pieceId, true);
            } else {
                // Incorrect slot placement registers snap penalty
                engineBridge.dispatchTelemetry(rootPiece.pieceId, false);
            }
        }
    }

    // Dynamic Mask Shader depending on Shape selection
    Rectangle {
        id: maskContainer
        anchors.fill: parent
        visible: false
        radius: rootPiece.shapeStyle === "square" ? 12 : 0

        // Custom shape drawer
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.fillStyle = "black";

                if (rootPiece.shapeStyle === "circle") {
                    ctx.beginPath();
                    ctx.arc(width / 2, height / 2, width * 0.48, 0, Math.PI * 2);
                    ctx.fill();
                } else if (rootPiece.shapeStyle === "triangle") {
                    ctx.beginPath();
                    if (rootPiece.pieceId % 2 === 0) {
                        ctx.moveTo(0, 0);
                        ctx.lineTo(width, 0);
                        ctx.lineTo(0, height);
                    } else {
                        ctx.moveTo(width, 0);
                        ctx.lineTo(width, height);
                        ctx.lineTo(0, height);
                    }
                    ctx.closePath();
                    ctx.fill();
                } else if (rootPiece.shapeStyle === "jigsaw") {
                    // Wavy Classic Jigsaw mask path coordinates
                    ctx.beginPath();
                    ctx.moveTo(width * 0.15, height * 0.15);

                    // Top edge tab
                    ctx.lineTo(width * 0.4, height * 0.15);
                    ctx.bezierCurveTo(width * 0.4, height * 0.05, width * 0.45, 0, width * 0.5, 0);
                    ctx.bezierCurveTo(width * 0.55, 0, width * 0.6, height * 0.05, width * 0.6, height * 0.15);
                    ctx.lineTo(width * 0.85, height * 0.15);

                    // Right edge slot
                    ctx.lineTo(width * 0.85, height * 0.4);
                    ctx.bezierCurveTo(width * 0.75, height * 0.4, width * 0.7, height * 0.45, width * 0.7, height * 0.5);
                    ctx.bezierCurveTo(width * 0.7, height * 0.55, width * 0.75, height * 0.6, width * 0.85, height * 0.6);
                    ctx.lineTo(width * 0.85, height * 0.85);

                    // Bottom edge tab
                    ctx.lineTo(width * 0.6, height * 0.85);
                    ctx.bezierCurveTo(width * 0.6, height * 0.95, width * 0.55, height, width * 0.5, height);
                    ctx.bezierCurveTo(width * 0.45, height, width * 0.4, height * 0.95, width * 0.4, height * 0.85);
                    ctx.lineTo(width * 0.15, height * 0.85);

                    // Left edge slot
                    ctx.lineTo(width * 0.15, height * 0.6);
                    ctx.bezierCurveTo(width * 0.25, height * 0.6, width * 0.3, height * 0.55, width * 0.3, height * 0.5);
                    ctx.bezierCurveTo(width * 0.3, height * 0.45, width * 0.25, height * 0.4, width * 0.15, height * 0.4);

                    ctx.closePath();
                    ctx.fill();
                }
            }
        }
    }

    Image {
        id: sourceImage
        anchors.fill: parent
        source: rootPiece.imageUrl
        fillMode: Image.Stretch
        visible: rootPiece.shapeStyle === "square" ? true : false
    }

    Image {
        id: maskedImage
        anchors.fill: parent
        source: rootPiece.imageUrl
        fillMode: Image.Stretch
        visible: false

        sourceSize.width: 480
        sourceSize.height: 480
    }

    MultiEffect {
        anchors.fill: parent

        source: maskedImage

        maskEnabled: true
        maskSource: maskContainer

        visible: rootPiece.shapeStyle !== "square"
    }
}

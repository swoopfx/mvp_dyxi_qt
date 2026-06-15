import QtQuick 6.5
import QtQuick.Layouts 6.5

Item {
    id: rootGrid
    property int gridSize: 2
    property string pieceShape: "jigsaw"
    property string sourceImage: "qrc:/modules/jigsaw/assets/fox.png"
    property var engineBridge

    width: 360
    height: 360

    // Grid Container for snap targets
    Grid {
        id: bgGrid
        anchors.fill: parent
        columns: gridSize
        rows: gridSize
        spacing: 0

        Repeater {
            model: gridSize * gridSize
            delegate: Rectangle {
                width: rootGrid.width / gridSize
                height: rootGrid.height / gridSize
                color: "#F1F5F9"
                border.color: "#CBD5E1"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: (index + 1).toString()
                    font.family: "JetBrains Mono"
                    font.pixelSize: 12
                    color: "#94A3B8"
                }
            }
        }
    }

    // Repeater for the interactive shuffled pieces with drag & drop functionality
    Repeater {
        model: gridSize * gridSize
        delegate: JigsawPiece {
            pieceId: modelData
            correctRow: Math.floor(modelData / gridSize)
            correctCol: modelData % gridSize
            cellSize: rootGrid.width / gridSize
            shapeStyle: rootGrid.pieceShape
            imageUrl: rootGrid.sourceImage
            engineBridge: rootGrid.engineBridge

            // Initial random scatter coordinates
            Component.onCompleted: {
                x = Math.random() * (rootGrid.width - cellSize);
                y = Math.random() * (rootGrid.height - cellSize);
            }
        }
    }

    // Helper function to solve nearest slot snap evaluation
    function findNearestSlot(px, py) {
        var cellSize = rootGrid.width / gridSize;
        var col = Math.round(px / cellSize);
        var row = Math.round(py / cellSize);

        // Clamp bounds
        col = Math.max(0, Math.min(col, gridSize - 1));
        row = Math.max(0, Math.min(row, gridSize - 1));

        return {
            "row": row,
            "col": col,
            "targetX": col * cellSize,
            "targetY": row * cellSize
        };
    }
}

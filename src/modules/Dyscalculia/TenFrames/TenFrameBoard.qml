import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    width: 600
    height: 300
    property int initialValue: 0
    readonly property int placedCount: counterRepeater.count - initialValue

    function reset() {
        // Handled by re-rendering when initialValue changes
    }

    Image {
        id: gridImage
        source: "qrc:/tenframegame/assets/images/ten_frame_grid.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    GridLayout {
        id: grid
        anchors.fill: parent
        anchors.margins: 20
        columns: 5
        rows: 2
        columnSpacing: 10
        rowSpacing: 10

        Repeater {
            model: 10
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"
                border.color: "transparent"
                
                DropArea {
                    anchors.fill: parent
                    onEntered: (drag) => {
                        drag.accept(Qt.MoveAction)
                    }
                    onDropped: (drop) => {
                        if (drop.source && !drop.source.isPlaced) {
                            drop.source.parent = parent
                            drop.source.anchors.centerIn = parent
                            drop.source.isPlaced = true
                        }
                    }
                }
            }
        }
    }

    // Initial Counters (Red)
    Repeater {
        model: initialValue
        Counter {
            color: "red"
            isPlaced: true
            x: grid.children[index].x + grid.anchors.margins
            y: grid.children[index].y + grid.anchors.margins
            width: grid.width / 5 - 20
            height: grid.height / 2 - 20
        }
    }

    // Available Counters to Drag (Blue)
    Flow {
        anchors.top: grid.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        spacing: 10
        
        Repeater {
            id: counterRepeater
            model: 10
            Counter {
                color: "blue"
                width: 60
                height: 60
            }
        }
    }
}

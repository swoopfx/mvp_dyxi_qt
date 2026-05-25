import QtQuick 2.15

Item {
    id: root
    property string color: "red"
    property bool isPlaced: false

    Image {
        id: img
        source: color === "red" ? "qrc:/tenframegame/assets/images/red_counter.png" : "../assets/images/blue_counter.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        
        Behavior on scale { NumberAnimation { duration: 200 } }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: root
        enabled: !isPlaced

        onPressed: {
            root.scale = 1.2
            root.z = 100
        }
        onReleased: {
            root.scale = 1.0
            if (!isPlaced) {
                // Return to original position if not dropped in a slot
                root.x = 0
                root.y = 0
            }
        }
    }
    
    Drag.active: dragArea.drag.active
    Drag.source: root
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2
}

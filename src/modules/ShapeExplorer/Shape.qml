import QtQuick 2.15

Item {
    id: root
    property string shapeType: ""
    property string imageSource: ""
    property bool isMatched: false
    property point startPos: Qt.point(0, 0)
    
    width: 120; height: 120

    signal dragStarted()
    signal dragEnded(real x, real y)

    Image {
        id: shapeImage
        source: root.imageSource
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        
        // 2D Depth Illusion: Drop Shadow and Scale
        layer.enabled: true
        scale: dragArea.pressed ? 1.1 : 1.0
        
        Behavior on scale { NumberAnimation { duration: 100 } }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: root
        
        onPressed:(mouse)=> {
            root.startPos = Qt.point(root.x, root.y)
            root.dragStarted()
             mouse.accepted = true
        }
        
        onReleased:(mouse)=> {
            root.dragEnded(root.x + root.width/2, root.y + root.height/2)
        }
        
        onPositionChanged: {
            // Potential for real-time hover feedback logic here
        }
    }
    
    states: [
        State {
            name: "matched"
            when: root.isMatched
            PropertyChanges { target: root; opacity: 0; scale: 0.5 }
        }
    ]
    
    transitions: Transition {
        NumberAnimation { properties: "opacity,scale"; duration: 500; easing.type: Easing.OutBack }
    }
}

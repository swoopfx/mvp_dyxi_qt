import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property int value: 1
    property bool draggable: false
    
    width: 100
    height: 100

    Image {
        id: shapeImage
        anchors.fill: parent
        source: "assets/images/numicon_" + value + ".png"
        fillMode: Image.PreserveAspectFit
        
        Behavior on scale { NumberAnimation { duration: 200 } }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.draggable
        drag.target: root
        
        onPressed: root.scale = 1.1
        onReleased: root.scale = 1.0
    }
}

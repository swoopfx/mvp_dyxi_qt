import QtQuick 2.15

Rectangle {
    id: root
    property string shapeType: ""
    property string imageSource: ""
    
    width: 140; height: 140
    color: "white"
    opacity: 0.3
    radius: 20
    border.color: "white"
    border.width: 2

    Image {
        id: shadowImage
        source: root.imageSource
        anchors.fill: parent
        anchors.margins: 10
        fillMode: Image.PreserveAspectFit
        opacity: 0.5
        // Silhouetted look
        layer.enabled: true
    }
    
    // Animation for when a shape is hovering near
    property bool isHovered: false
    scale: isHovered ? 1.1 : 1.0
    Behavior on scale { NumberAnimation { duration: 200 } }
}

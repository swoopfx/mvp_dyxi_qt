import QtQuick

Item {
    id: colorDrop
    width: 80
    height: 80

    property color paintColor: "red"
    property point originalPos: Qt.point(x, y)
    
    signal dragStarted()
    signal dropped(bool success, real dropX, real dropY)
    signal positionChanged(real px, real py)

    Rectangle {
        id: visualCircle
        anchors.fill: parent
        radius: width / 2
        color: paintColor
        border.color: "black"
        border.width: 2
        
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "transparent"
            border.color: "white"
            border.width: 1
            opacity: 0.5
        }
        
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.target: visualCircle
            
            onPressed: {
                originalPos = Qt.point(visualCircle.x, visualCircle.y);
                colorDrop.dragStarted();
            }
            
            onPositionChanged: {
                if (drag.active) {
                    let globalPos = visualCircle.mapToGlobal(mouseArea.mouseX, mouseArea.mouseY);
                    colorDrop.positionChanged(globalPos.x, globalPos.y);
                }
            }
            
            onReleased: {
                let globalPos = visualCircle.mapToGlobal(mouseArea.mouseX, mouseArea.mouseY);
                colorDrop.dropped(true, globalPos.x, globalPos.y);
                
                // Return to original position
                returnAnimation.start();
            }
        }
        
        PropertyAnimation {
            id: returnAnimation
            target: visualCircle
            property: "x"
            to: originalPos.x
            duration: 300
            easing.type: Easing.OutQuad
        }
        
        PropertyAnimation {
            id: returnAnimationY
            target: visualCircle
            property: "y"
            to: originalPos.y
            duration: 300
            easing.type: Easing.OutQuad
        }
    }
}

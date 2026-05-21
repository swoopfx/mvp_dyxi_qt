import QtQuick 2.15

Item {
    id: root
    width: 200; height: 200
    visible: false
    
    property real visibilityStartTime: 0
    
    Image {
        source: "qrc:/recognition/ShapeExplorer/assets/rabbit.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }
    
    function show() {
        root.x = Math.random() * (parent.width - root.width)
        root.y = Math.random() * (parent.height - root.height)
        root.visible = true
        root.visibilityStartTime = Date.now()
        hideTimer.start()
    }
    
    Timer {
        id: hideTimer
        interval: 3000
        onTriggered: root.visible = false
    }
    
    Behavior on visible {
        NumberAnimation { target: root; property: "opacity"; from: 0; to: 1; duration: 300 }
    }
}

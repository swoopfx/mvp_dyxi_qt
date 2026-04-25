import QtQuick
import QtQuick.Controls

Button {
    id: control
    property int level: 1
    property string title: ""
    property color color: "white"
    
    contentItem: Text {
        text: level + "\n" + title
        font.family: dyslexiaFont.name
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "#4A4A4A"
    }
    
    background: Rectangle {
        implicitWidth: 180
        implicitHeight: 180
        radius: 20
        color: control.down ? Qt.darker(control.color, 1.2) : control.color
        border.width: 5
        border.color: "white"
        
        layer.enabled: true
        layer.effect: ShaderEffect {
            // Placeholder for a simple shadow effect if needed
        }
    }
}

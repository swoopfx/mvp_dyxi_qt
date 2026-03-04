import QtQuick 2.15
import QtQuick.Controls

Item {
    id: imageButton
    width: 300
    height: 300

    property alias source: image.source
    signal clicked

    scale: MouseArea.containsMouse ? 1.1 : 1.0

    Behavior on scale {
        NumberAnimation{
            duration: 200
            easing.type : Easing.OutBack
        }
    }

    Image {
        id: image
        anchors.fill : parent
        smooth: true
        fillMode: Image.PreserveAspectFit
    }

    Rectangle{
        anchors.fill: parent
        color: "transparent"
        border.color: mouseArea.containsMouse ? "#00BFFF" : "transparent"
        border.width: 6
        radius: 20
    }

    MouseArea{
        id:mouseArea
        anchors.fill:  parent
        hoverEnabled: true
        onClicked: imageButton.clicked()
    }

}

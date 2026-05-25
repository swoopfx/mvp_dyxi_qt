import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property int value: 1
    property bool interactive: true
    signal clicked(int val)

    width: 150
    height: 150

    Image {
        id: tileImage
        anchors.fill: parent
        source: "qrc:/numicon/assets/images/numicon_" + root.value + ".png"
        fillMode: Image.PreserveAspectFit
        smooth: true
        antialiasing: true
        
        // Shadow effect
        layer.enabled: true
        layer.effect: ShaderEffect {
            property variant source: tileImage
            fragmentShader: "
                varying highp vec2 qt_TexCoord0;
                uniform sampler2D source;
                void main() {
                    gl_FragColor = texture2D(source, qt_TexCoord0);
                }
            "
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.interactive
        hoverEnabled: true
        onClicked: {
            clickAnim.start()
            root.clicked(root.value)
        }
        onEntered: hoverAnim.start()
        onExited: hoverExitAnim.start()
    }

    SequentialAnimation {
        id: clickAnim
        NumberAnimation { target: tileImage; property: "scale"; to: 0.9; duration: 50; easing.type: Easing.InOutQuad }
        NumberAnimation { target: tileImage; property: "scale"; to: 1.0; duration: 50; easing.type: Easing.InOutQuad }
    }

    NumberAnimation {
        id: hoverAnim
        target: tileImage
        property: "scale"
        to: 1.1
        duration: 200
        easing.type: Easing.OutBack
    }

    NumberAnimation {
        id: hoverExitAnim
        target: tileImage
        property: "scale"
        to: 1.0
        duration: 200
        easing.type: Easing.OutBack
    }

    // Floating animation
    SequentialAnimation {
        running: true
        loops: Animation.Infinite
        NumberAnimation { target: tileImage; property: "anchors.verticalCenterOffset"; from: -5; to: 5; duration: 2000; easing.type: Easing.InOutSine }
        NumberAnimation { target: tileImage; property: "anchors.verticalCenterOffset"; from: 5; to: -5; duration: 2000; easing.type: Easing.InOutSine }
    }
}

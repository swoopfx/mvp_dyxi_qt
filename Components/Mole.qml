import QtQuick 2.15

Item {
    id: root
    width: 150
    height: 150

    property bool active: false
    property real shownAtMs: 0
    property real pressDownAtMs: 0

    signal hit(real shownAt, real pressDownAt, real pressDuration)

    Image {
        id: holeImage
        anchors.fill: parent
        source:"qrc:/img/images/hole.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: rabbitImage
        width: parent.width * 0.8
        height: parent.height * 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: active ? 20 : -height
        source:"qrc:/img/images/rabbit.png"
        fillMode: Image.PreserveAspectFit
        opacity: active ? 1 : 0

        Behavior on anchors.bottomMargin {
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    MouseArea {
        anchors.fill: parent
        property real localPressStart: 0

        onPressed: {
            localPressStart = Date.now();
            if (active) {
                root.pressDownAtMs = localPressStart;
            }
        }

        onReleased: {
            var now = Date.now();
            var clickDuration = now - localPressStart;

            if (active) {
                root.hit(root.shownAtMs, root.pressDownAtMs, clickDuration);
                active = false;
                gameWindow.recordWhackAttempt(true, clickDuration);
            } else {
                gameWindow.recordWhackAttempt(false, clickDuration);
            }
        }
    }

    function popUp() {
        active = true;
        shownAtMs = Date.now();
    }

    function hide() {
        active = false;
    }
}

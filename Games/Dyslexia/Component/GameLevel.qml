import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
    id: levelRoot
    signal backToMenu()

    property int levelId: 1
    property int currentSoundIndex: 0
    property var currentSoundData: null
    property int stars: 0

    PhonicsData { id: dataModel }

    function updateLevelData() {
        var filteredSounds = dataModel.sounds.filter(function(s) { return s.level === levelId; });
        if (currentSoundIndex < filteredSounds.length) {
            currentSoundData = filteredSounds[currentSoundIndex];
            characterEmoji.text = "🤖";
            targetArea.color = "#E0E0E0";
            draggableLetter.x = 100;
            draggableLetter.y = 100;
            draggableLetter.opacity = 1;
            speakText("Find the letter " + currentSoundData.sound);
        } else {
            characterEmoji.text = "🏆";
            levelCompleteDialog.open();
        }
    }

    function speakText(text) {
        console.log("TTS Speaking: " + text);
    }

    Component.onCompleted: updateLevelData()

    Column {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 20

        Row {
            width: parent.width
            spacing: 20
            Button {
                text: "⬅ Back"
                onClicked: levelRoot.backToMenu()
                background: Rectangle {
                    color: "#f0f0f0"
                    radius: 10
                    border.color: "#ccc"
                }
            }
            Text {
                text: "Level " + levelId + " - Progress: " + (currentSoundIndex + 1) + "/" + dataModel.sounds.filter(function(s) { return s.level === levelId; }).length
                font.pixelSize: 24
                font.family: "Verdana"
                color: "#333333"
            }
            Item { width: 50 } // Spacer
            Text {
                text: "⭐ " + stars
                font.pixelSize: 24
                font.bold: true
                color: "#FFD700"
            }
        }

        Rectangle {
            width: parent.width
            height: 150
            color: "transparent"
            Row {
                anchors.centerIn: parent
                spacing: 20
                Text {
                    id: characterEmoji
                    text: "🤖"
                    font.pixelSize: 80
                    
                    SequentialAnimation on scale {
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 1.1; duration: 1000; easing.type: Easing.InOutQuad }
                        NumberAnimation { from: 1.1; to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
                    }
                }
                Rectangle {
                    width: 400
                    height: 100
                    color: "white"
                    radius: 20
                    border.color: "#333"
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 2
                        verticalOffset: 2
                        color: "#80000000"
                    }
                    Text {
                        text: currentSoundData ? "Can you find the sound '" + currentSoundData.sound + "' and drag it to the " + currentSoundData.word + "?" : ""
                        anchors.centerIn: parent
                        font.pixelSize: 18
                        font.family: "Verdana"
                        font.letterSpacing: 1.5 // Dyslexia-friendly spacing
                        lineHeight: 1.2
                        wrapMode: Text.WordWrap
                        width: parent.width - 20
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: 300

            Rectangle {
                id: targetArea
                width: 220
                height: 220
                anchors.right: parent.right
                anchors.rightMargin: 100
                anchors.verticalCenter: parent.verticalCenter
                color: "#E0E0E0"
                radius: 30
                border.color: "#999"
                border.width: 4

                Text {
                    text: currentSoundData ? currentSoundData.image : ""
                    font.pixelSize: 120
                    anchors.centerIn: parent
                }

                DropArea {
                    anchors.fill: parent
                    onEntered: targetArea.color = "#C8E6C9"
                    onExited: targetArea.color = "#E0E0E0"
                    onDropped: {
                        if (drop.source.text === currentSoundData.sound) {
                            targetArea.color = "#4CAF50";
                            characterEmoji.text = "🎉";
                            stars += 10;
                            successAnimation.start();
                            speakText("Fantastic! " + currentSoundData.sound + " is for " + currentSoundData.word);
                            nextSoundTimer.start();
                        } else {
                            targetArea.color = "#FFCDD2";
                            characterEmoji.text = "🤔";
                            speakText("Not quite! Let's try that sound again.");
                            failAnimation.start();
                        }
                    }
                }
            }

            Rectangle {
                id: draggableLetter
                width: 140
                height: 140
                x: 100
                y: 100
                color: "#FFEB3B"
                radius: 20
                border.color: "#FBC02D"
                border.width: 4
                
                property string text: currentSoundData ? currentSoundData.sound : ""

                Text {
                    text: parent.text
                    anchors.centerIn: parent
                    font.pixelSize: 70
                    font.bold: true
                    font.family: "Verdana"
                }

                Drag.active: dragMouseArea.drag.active
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                MouseArea {
                    id: dragMouseArea
                    anchors.fill: parent
                    drag.target: draggableLetter
                    onReleased: {
                        if (!draggableLetter.Drag.target) {
                            returnAnimation.start();
                        }
                    }
                }

                NumberAnimation {
                    id: returnAnimation
                    target: draggableLetter
                    properties: "x,y"
                    to: 100
                    duration: 500
                    easing.type: Easing.OutElastic
                }
            }
        }
    }

    SequentialAnimation {
        id: successAnimation
        NumberAnimation { target: targetArea; property: "scale"; from: 1.0; to: 1.2; duration: 200; easing.type: Easing.OutQuad }
        NumberAnimation { target: targetArea; property: "scale"; from: 1.2; to: 1.0; duration: 200; easing.type: Easing.InQuad }
    }

    SequentialAnimation {
        id: failAnimation
        NumberAnimation { target: draggableLetter; property: "x"; to: draggableLetter.x + 10; duration: 50 }
        NumberAnimation { target: draggableLetter; property: "x"; to: draggableLetter.x - 10; duration: 50 }
        NumberAnimation { target: draggableLetter; property: "x"; to: draggableLetter.x + 10; duration: 50 }
        NumberAnimation { target: draggableLetter; property: "x"; to: draggableLetter.x; duration: 50 }
    }

    Timer {
        id: nextSoundTimer
        interval: 2500
        onTriggered: {
            currentSoundIndex++;
            updateLevelData();
        }
    }

    Dialog {
        id: levelCompleteDialog
        title: "Level Complete!"
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Ok
        contentItem: Column {
            spacing: 20
            Text {
                text: "Amazing Work!"
                font.pixelSize: 30
                font.bold: true
                font.family: "Verdana"
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }
            Text {
                text: "You've mastered Level " + levelId + " and earned " + stars + " stars!"
                font.pixelSize: 18
                font.family: "Verdana"
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }
        }
        onAccepted: {
            levelId++;
            currentSoundIndex = 0;
            updateLevelData();
        }
    }
}

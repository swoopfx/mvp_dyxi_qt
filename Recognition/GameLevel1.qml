import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: level1
    
    property string targetItem: "A"
    property var options: ["A", "B", "C", "D"]
    property int score: 0
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 40

        RowLayout {
            Layout.fillWidth: true
            Button {
                text: "Back"
                onClicked: stackView.pop()
                font.family: dyslexiaFont.name
                font.pixelSize: 20
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "Score: " + score
                font.family: dyslexiaFont.name
                font.pixelSize: 30
                color: "#4A4A4A"
            }
        }

        Text {
            text: "Find the letter: " + targetItem
            font.family: dyslexiaFont.name
            font.pixelSize: 50
            color: "#4A4A4A"
            Layout.alignment: Qt.AlignHCenter
        }

        GridLayout {
            columns: 2
            rows: 2
            Layout.alignment: Qt.AlignHCenter
            rowSpacing: 20
            columnSpacing: 20

            Repeater {
                model: options
                delegate: Button {
                    id: cardBtn
                    property string letter: modelData
                    
                    background: Image {
                        source: "assets/images/card_base.png"
                        width: 250
                        height: 250
                        opacity: cardBtn.down ? 0.8 : 1.0
                    }
                    
                    contentItem: Text {
                        text: letter
                        font.family: dyslexiaFont.name
                        font.pixelSize: 120
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#4A4A4A"
                    }
                    
                    onClicked: {
                        if (letter === targetItem) {
                            score += 10
                            gameEngine.playSound("correct.wav")
                            generateNewChallenge()
                        } else {
                            // Shake animation or sound for wrong answer
                            gameEngine.playSound("wrong.wav")
                            shakeAnim.start()
                        }
                    }
                    
                    SequentialAnimation {
                        id: shakeAnim
                        NumberAnimation { target: cardBtn; property: "x"; from: cardBtn.x; to: cardBtn.x - 10; duration: 50 }
                        NumberAnimation { target: cardBtn; property: "x"; from: cardBtn.x - 10; to: cardBtn.x + 10; duration: 50 }
                        NumberAnimation { target: cardBtn; property: "x"; from: cardBtn.x + 10; to: cardBtn.x; duration: 50 }
                    }
                }
            }
        }
    }
    
    function generateNewChallenge() {
        var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        targetItem = alphabet.charAt(Math.floor(Math.random() * alphabet.length))
        
        var newOptions = [targetItem]
        while (newOptions.length < 4) {
            var randomChar = alphabet.charAt(Math.floor(Math.random() * alphabet.length))
            if (newOptions.indexOf(randomChar) === -1) {
                newOptions.push(randomChar)
            }
        }
        
        // Shuffle options
        for (var i = newOptions.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var temp = newOptions[i];
            newOptions[i] = newOptions[j];
            newOptions[j] = temp;
        }
        options = newOptions
    }
    
    Component.onCompleted: generateNewChallenge()
}

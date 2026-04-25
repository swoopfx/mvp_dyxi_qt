import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: level2
    
    property string targetLetter: "A"
    property string targetImage: "apple"
    property var letterOptions: ["A", "B", "C", "D"]
    property int score: 0
    
    // Mapping of letters to simple objects for matching
    readonly property var itemMap: {
        "A": "apple", "B": "ball", "C": "cat", "D": "dog", "E": "egg",
        "F": "fish", "G": "goat", "H": "hat", "I": "ice", "J": "jam",
        "K": "kite", "L": "lion", "M": "moon", "N": "nest", "O": "owl",
        "P": "pig", "Q": "queen", "R": "rat", "S": "sun", "T": "tree",
        "U": "up", "V": "van", "W": "web", "X": "box", "Y": "yo-yo", "Z": "zebra"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 30

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
            text: "Which letter starts with this?"
            font.family: dyslexiaFont.name
            font.pixelSize: 40
            color: "#4A4A4A"
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            id: imageDisplay
            Layout.preferredWidth: 200
            Layout.preferredHeight: 200
            Layout.alignment: Qt.AlignHCenter
            color: "white"
            radius: 20
            border.width: 5
            border.color: "#87CEEB"
            
            Text {
                anchors.centerIn: parent
                text: targetImage.toUpperCase()
                font.family: dyslexiaFont.name
                font.pixelSize: 40
                color: "#4A4A4A"
            }
            
            // In a real app, we'd use an Image component here
            // Image { source: "assets/images/objects/" + targetImage + ".png"; anchors.fill: parent; fillMode: Image.PreserveAspectFit }
        }

        GridLayout {
            columns: 2
            Layout.alignment: Qt.AlignHCenter
            rowSpacing: 20
            columnSpacing: 20

            Repeater {
                model: letterOptions
                delegate: Button {
                    id: cardBtn
                    property string letter: modelData
                    
                    background: Image {
                        source: "assets/images/card_base.png"
                        width: 200
                        height: 200
                        opacity: cardBtn.down ? 0.8 : 1.0
                    }
                    
                    contentItem: Text {
                        text: letter
                        font.family: dyslexiaFont.name
                        font.pixelSize: 100
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#4A4A4A"
                    }
                    
                    onClicked: {
                        if (letter === targetLetter) {
                            score += 15
                            generateNewChallenge()
                        } else {
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
        var keys = Object.keys(itemMap)
        targetLetter = keys[Math.floor(Math.random() * keys.length)]
        targetImage = itemMap[targetLetter]
        
        var newOptions = [targetLetter]
        while (newOptions.length < 4) {
            var randomChar = keys[Math.floor(Math.random() * keys.length)]
            if (newOptions.indexOf(randomChar) === -1) {
                newOptions.push(randomChar)
            }
        }
        
        // Shuffle
        for (var i = newOptions.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var temp = newOptions[i];
            newOptions[i] = newOptions[j];
            newOptions[j] = temp;
        }
        letterOptions = newOptions
    }
    
    Component.onCompleted: generateNewChallenge()
}

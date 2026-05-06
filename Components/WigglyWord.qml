import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import mvpDyxi
// import "../Components"



Page {
    id: root
    visible: true
   anchors.fill: parent


    // title: "Wiggly Words - Mega Fun Edition"
    // color: "#87CEEB"

    property var words: ["APPLE", "BANANA", "CAT", "DOG", "ELEPHANT", "FROG", "GIRAFFE", "HIPPO"]
    property int currentWordIndex: 0
    property string currentWord: words[currentWordIndex]
    property string userProgress: ""
    property string instruction: "Find the letters for: " + currentWord


   GameEngine{
       id: gameEngine
   }

    // Animated Graphical Background
    Image {
        id: bgImage
        anchors.fill: parent
        source: "qrc:/img/images/assets/game_background.png"
        fillMode: Image.PreserveAspectCrop

        // Back Button (Top Left)
        Button {
            id: backButton
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 25
            width: 120; height: 50
            z: 100

            background: Rectangle {
                color: backButton.pressed ? "#c0392b" : "#e74c3c"
                radius: 25
                border.color: "white"
                border.width: 3
            }

            contentItem: Text {
                text: "⬅ BACK"
                color: "white"
                font.bold: true
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                gameEngine.logActivity("navigation", {"action": "back_clicked"})
                stackView.pop()
                // Logic for going back can be added here
            }
        }

        // Submit Button (Bottom Right)
        Button {
            id: submitButton
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 25
            width: 150; height: 60
            z: 100

            background: Rectangle {
                color: submitButton.pressed ? "#27ae60" : "#2ecc71"
                radius: 30
                border.color: "white"
                border.width: 4
            }

            contentItem: Text {
                text: "SUBMIT ✔"
                color: "white"
                font.bold: true
                font.pixelSize: 22
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: {
                gameEngine.logActivity("submit_clicked", {"current_progress": userProgress})
                if (userProgress === currentWord) {
                    gameEngine.speak("Excellent submission!")
                    successAnim.start()
                    nextWord()
                } else {
                    gameEngine.speak("Wait! The word isn't finished yet!")
                    errorAnim.start()
                }
            }
        }

        // Comical cloud floating animation
        Repeater {
            model: 3
            delegate: Rectangle {
                width: 150 + index * 50; height: 80 + index * 20
                color: "white"
                radius: 40
                opacity: 0.5
                y: 50 + index * 100

                NumberAnimation on x {
                    from: -300; to: root.width + 300
                    duration: 15000 + index * 5000
                    loops: Animation.Infinite
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 30

        // Header Section
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            Rectangle {
                width: 650; height: 110
                color: "#EEFFFFFF"
                radius: 55
                border.color: "#f1c40f"
                border.width: 6

                Text {
                    anchors.centerIn: parent
                    text: instruction
                    font.pixelSize: 46
                    font.family: "Comic Sans MS"
                    font.bold: true
                    color: "#2c3e50"

                    SequentialAnimation on scale {
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 1.05; duration: 600; easing.type: Easing.InOutSine }
                        NumberAnimation { from: 1.05; to: 1.0; duration: 600; easing.type: Easing.InOutSine }
                    }
                }
            }

            // Image {
            //     source: "qrc:/img/images/assets/replay_button.png"
            //     width: 10; height: 10
            //     // fillMode: Image.PreserveAspectFit

            //     MouseArea {
            //         anchors.fill: parent
            //         onClicked: {
            //             gameEngine.speak(instruction)
            //             gameEngine.logActivity("replay_instruction", {"instruction": instruction})
            //             replayAnim.start()
            //         }
            //     }

            //     SequentialAnimation {
            //         id: replayAnim
            //         NumberAnimation { target: parent; property: "scale"; to: 1.3; duration: 150; easing.type: Easing.OutBack }
            //         NumberAnimation { target: parent; property: "scale"; to: 1.0; duration: 150; easing.type: Easing.InBack }
            //     }
            // }
        }

        // Word Display Area with MEGA Embossed Letters
        Row {
            id: wordDisplay
            spacing: 25
            Layout.alignment: Qt.AlignHCenter

            Repeater {
                model: currentWord.length
                delegate: Item {
                    width: 110; height: 140

                    Rectangle {
                        id: letterBox
                        anchors.fill: parent
                        radius: 30
                        color: index < userProgress.length ? "#2ecc71" : "#ecf0f1"
                        border.color: "white"
                        border.width: 6

                        // 3D Embossed Depth
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width; height: 10
                            color: "#80000000"
                            opacity: 0.2
                            radius: 30
                            visible: index < userProgress.length
                        }

                        Text {
                            anchors.centerIn: parent
                            text: currentWord[index]
                            font.pixelSize: 80
                            font.bold: true
                            color: "white"
                            visible: index < userProgress.length

                            style: Text.Outline
                            styleColor: "#27ae60"

                            onVisibleChanged: {
                                if (visible) {
                                    bounceIn.start()
                                    wiggleFast.start()
                                }
                            }

                            SequentialAnimation {
                                id: bounceIn
                                NumberAnimation { target: letterBox; property: "scale"; from: 0.2; to: 1.3; duration: 300; easing.type: Easing.OutBack }
                                NumberAnimation { target: letterBox; property: "scale"; to: 1.0; duration: 150 }
                            }

                            SequentialAnimation {
                                id: wiggleFast
                                NumberAnimation { target: letterBox; property: "rotation"; from: -15; to: 15; duration: 100 }
                                NumberAnimation { target: letterBox; property: "rotation"; from: 15; to: 0; duration: 100 }
                            }
                        }

                        // Comical wiggle for unrevealed letters
                        SequentialAnimation on rotation {
                            loops: Animation.Infinite
                            running: index >= userProgress.length
                            NumberAnimation { from: -10; to: 10; duration: 200 + Math.random() * 200; easing.type: Easing.InOutQuad }
                            NumberAnimation { from: 10; to: -10; duration: 200 + Math.random() * 200; easing.type: Easing.InOutQuad }
                        }
                    }
                }
            }
        }

        // Graphical Alphabet Keyboard
        Flow {
            id: keyboard
            Layout.fillWidth: true
            Layout.preferredHeight: 320
            spacing: 18
            Layout.alignment: Qt.AlignHCenter
            // z:20

            Repeater {
                model: "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
                delegate: Button {
                    id: keyBtn
                    width: 80; height: 80

                    background: Rectangle {
                        color: keyBtn.pressed ? "#e74c3c" : "#3498db"
                        // color:"transparent"
                        radius: 25
                        border.color: "white"
                        border.width: 5

                        // 3D Highlight
                        Rectangle {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.margins: 6
                            width: parent.width * 0.4; height: 15
                            color: "white"
                            opacity: 0.3
                            radius: 10
                        }
                    }

                    contentItem: Text {
                        text: keyBtn.text
                        font.pixelSize: 40
                        font.bold: true
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        // Comical pop on press
                        scale: keyBtn.pressed ? 0.7 : 1.0
                        Behavior on scale { NumberAnimation { duration: 60; easing.type: Easing.OutBack } }
                    }

                    onClicked: {
                        checkLetter(text)
                    }
                }
            }
        }

        // Stats Overlay
        // Rectangle {
        //     Layout.alignment: Qt.AlignRight
        //     width: 350; height: 220
        //     color: "#CC2c3e50"
        //     radius: 35
        //     border.color: "#f1c40f"
        //     border.width: 5

        //     Column {
        //         anchors.fill: parent
        //         anchors.margins: 25
        //         spacing: 10

        //         Text { color: "#f1c40f"; text: "🌈 SUPER STATS 🌈"; font.bold: true; font.pixelSize: 24; font.family: "Comic Sans MS" }

        //         property var metrics: JSON.parse(gameEngine.metricsJson)

        //         Text { color: "white"; text: "🎯 Accuracy: " + parent.metrics.accuracy + "%"; font.pixelSize: 20 }
        //         Text { color: "white"; text: "⚡ Fluency: " + parent.metrics.fluency_index; font.pixelSize: 20 }
        //         Text { color: "#55efc4"; text: "🏆 Progress: " + parent.metrics.progress_monitoring_index; font.bold: true; font.pixelSize: 22 }

        //         Button {
        //             text: "SAVE MY PROGRESS"
        //             onClicked: gameEngine.exportData()
        //             width: parent.width - 50
        //             height: 45
        //             background: Rectangle { color: "#e67e22"; radius: 15 }
        //             contentItem: Text { text: parent.text; color: "white"; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
        //         }
        //     }
        // }
    }

    function checkLetter(letter) {
        var expected = currentWord[userProgress.length]
        var isCorrect = (letter === expected)

        gameEngine.logActivity("letter_input", {
            "letter": letter,
            "expected": expected,
            "is_correct": isCorrect,
            "current_word": currentWord
        })

        if (isCorrect) {
            userProgress += letter
            if (userProgress === currentWord) {
                gameEngine.logActivity("word_completed", {"word": currentWord})
                gameEngine.speak("Boom! You did it! " + currentWord + " is finished!")
                successAnim.start()
                nextWord()
            }
        } else {
            gameEngine.speak("Try again! Look for the letter " + expected)
            errorAnim.start()
        }
    }

    SequentialAnimation {
        id: errorAnim
        NumberAnimation { target: root; property: "x"; to: root.x + 10; duration: 50 }
        NumberAnimation { target: root; property: "x"; to: root.x - 10; duration: 50 }
        NumberAnimation { target: root; property: "x"; to: root.x + 10; duration: 50 }
        NumberAnimation { target: root; property: "x"; to: root.x; duration: 50 }
    }

    SequentialAnimation {
        id: successAnim
        NumberAnimation { target: wordDisplay; property: "scale"; to: 1.2; duration: 200; easing.type: Easing.OutBack }
        NumberAnimation { target: wordDisplay; property: "scale"; to: 1.0; duration: 200; easing.type: Easing.InBack }
    }

    function nextWord() {
        userProgress = ""
        currentWordIndex = (currentWordIndex + 1) % words.length
        currentWord = words[currentWordIndex]
        instruction = "Spell the word: " + currentWord
        gameEngine.speak(instruction)
    }

    Component.onCompleted: {
        gameEngine.speak(instruction)
    }
}

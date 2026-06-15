import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Phonetics.WordRecognitionGame2

Page {
    id: window
    anchors.fill: parent
    visible: true
    // title: "Qt6 Kid's Word Recognition Game"
    // color: "#f0f9ff" // soft light-blue sky background matching ages 3-10

    // Core Session Properties
    property string childName: "Steve"
    property int currentWordIndex: 0
    property string gameState: "idle" // idle, countdown, welcome, reading, listening, comical_reprompt, success
    property int countdownSeconds: 2
    property int listenCountdown: 5
    property string textHighlightWord: ""
    property int highlightCharIndex: -1
    property int repetitionCounter: 0
    property real timeTakenStart: 0

    property int currentLetterIndex: 0
    property bool speakingWholeWord: false
    property bool waitingForQuestionTts: false

    // Database of 80 colourful animal, object, and thing 3 and 4 letter words
    ListModel {
        id: wordDatabaseList
        ListElement {
            word: "CAT"
            category: "animal"
            difficulty: 3
            emoji: "🐱"
            colorBegin: "#FF9E9E"
            colorEnd: "#FF6F6F"
            shape: "cat"
        }
        ListElement {
            word: "DOG"
            category: "animal"
            difficulty: 3
            emoji: "🐶"
            colorBegin: "#FFD384"
            colorEnd: "#F1AA41"
            shape: "dog"
        }
        ListElement {
            word: "PIG"
            category: "animal"
            difficulty: 3
            emoji: "🐷"
            colorBegin: "#FFAAAA"
            colorEnd: "#FF8B94"
            shape: "pig"
        }
        ListElement {
            word: "COW"
            category: "animal"
            difficulty: 3
            emoji: "🐮"
            colorBegin: "#D8D8D8"
            colorEnd: "#9B9B9B"
            shape: "cow"
        }
        ListElement {
            word: "FOX"
            category: "animal"
            difficulty: 3
            emoji: "🦊"
            colorBegin: "#FFAE68"
            colorEnd: "#FF7844"
            shape: "fox"
        }
        ListElement {
            word: "OWL"
            category: "animal"
            difficulty: 3
            emoji: "🦉"
            colorBegin: "#B983FF"
            colorEnd: "#94B3FD"
            shape: "owl"
        }
        ListElement {
            word: "BAT"
            category: "animal"
            difficulty: 3
            emoji: "🦇"
            colorBegin: "#4E31AA"
            colorEnd: "#379237"
            shape: "bat"
        }
        ListElement {
            word: "BEE"
            category: "animal"
            difficulty: 3
            emoji: "🐝"
            colorBegin: "#FFF56D"
            colorEnd: "#FFC715"
            shape: "bee"
        }
        ListElement {
            word: "BUG"
            category: "animal"
            difficulty: 3
            emoji: "🐛"
            colorBegin: "#9EFF9E"
            colorEnd: "#55C355"
            shape: "bug"
        }
        ListElement {
            word: "SUN"
            category: "thing"
            difficulty: 3
            emoji: "☀️"
            colorBegin: "#FFE082"
            colorEnd: "#E65100"
            shape: "sun"
        }
        ListElement {
            word: "CAR"
            category: "object"
            difficulty: 3
            emoji: "🚗"
            colorBegin: "#FF5D5D"
            colorEnd: "#C70039"
            shape: "car"
        }
        ListElement {
            word: "CAKE"
            category: "thing"
            difficulty: 4
            emoji: "🍰"
            colorBegin: "#F8BBD0"
            colorEnd: "#C2185B"
            shape: "cake"
        }
        ListElement {
            word: "TREE"
            category: "object"
            difficulty: 4
            emoji: "🌳"
            colorBegin: "#A5D6A7"
            colorEnd: "#2E7D32"
            shape: "tree"
        }
        ListElement {
            word: "MOON"
            category: "thing"
            difficulty: 4
            emoji: "🌙"
            colorBegin: "#ECEFF1"
            colorEnd: "#455A64"
            shape: "moon"
        }
        ListElement {
            word: "BALL"
            category: "object"
            difficulty: 4
            emoji: "⚽"
            colorBegin: "#FF8A80"
            colorEnd: "#FF5252"
            shape: "ball"
        }
    }

    SpeechProcessor {
        id: cppSpeechProcessor
    }

    // C++ Speech Recognition, Analytics & Backend-driven TTS Engine hook (SpeechProcessor)
    // Injected into QML context by the main.cpp regulator.
    Connections {
        target: cppSpeechProcessor

        onSpeechEvaluationCompleted: (accuracy, fluency, vocab, memory, consistency, speechRate, pronunciationGrade, logJson) => {
            console.log("C++ Engine Analysis returned: Accuracy=" + accuracy + " Fluency=" + fluency + " Consistency=" + consistency + " Grade=" + pronunciationGrade);
            if (accuracy >= 65) {
                window.gameState = "success";
                cppSpeechProcessor.speak("Awesome job " + childName + "! You read that word perfectly!");
            } else {
                window.gameState = "comical_reprompt";
                cppSpeechProcessor.speak("I can't hear you!"); // Comical Reprompt
            }
        }

        onRecordingFailed: errorMsg => {
            console.log("Local audio hardware failure: " + errorMsg);
        }

        // Receives event from core when backend audio playback completes!
        onTtsPlayFinished: {
            window.handleTTSFinished();
        }
    }

    // Sequence Cycle Timers
    Timer {
        id: gamePageDelayTimer
        interval: 2000 // 2 seconds welcome pause
        repeat: false
        onTriggered: {
            window.gameState = "welcome";
            cppSpeechProcessor.speak("Welcome " + window.childName + ", I would like you to read what you see.");
        }
    }

    Timer {
        id: welcomePauseTimer
        interval: 1000 // 1 second gap
        repeat: false
        onTriggered: {
            window.repetitionCounter = 1;
            window.gameState = "reading";
            window.readWordProgressively();
        }
    }

    Timer {
        id: listeningTimer
        interval: 1000
        repeat: true
        running: window.gameState === "listening"
        onTriggered: {
            window.listenCountdown--;
            if (window.listenCountdown <= 0) {
                // listeningTimer.stop()
                stop();
                window.stopAudioCaptureAndAnalyze();
            }
        }
    }

    // Game Logic Helpers
    function startGameCycleCurrentWord() {
        gamePageDelayTimer.stop();
        welcomePauseTimer.stop();
        listeningTimer.stop();
        window.highlightCharIndex = -1;

        window.gameState = "countdown";
        window.countdownSeconds = 2;
        gamePageDelayTimer.start();
        console.log("QML loaded target word: " + wordDatabaseList.get(currentWordIndex).word);
    }

    function readWordProgressively() {
        // if (window.gameState !== "reading") return;
        // var element = wordDatabaseList.get(currentWordIndex);

        // console.log("Pronouncing repetition round: " + window.repetitionCounter + " for " + element.word);
        // cppSpeechProcessor.speak(element.word);

        if (window.gameState !== "reading")
            return;

        var word = wordDatabaseList.get(window.currentWordIndex).word;

        window.currentLetterIndex = 0;
        window.speakingWholeWord = false;

        console.log("Starting spelling sequence for:", word);

        window.highlightCharIndex = 0;

        cppSpeechProcessor.speak(word.charAt(0));
    }

    function handleTTSFinished() {
        var word = wordDatabaseList.get(window.currentWordIndex).word;

        // Welcome completed
        if (window.gameState === "welcome") {
            welcomePauseTimer.start();
            return;
        }

        // Question prompt completed
        if (window.waitingForQuestionTts) {
            window.waitingForQuestionTts = false;

            console.log("Starting recording");

            window.startAudioCapture();
            return;
        }

        // Reading sequence
        if (window.gameState === "reading") {

            // Still spelling letters
            if (!window.speakingWholeWord) {
                window.currentLetterIndex++;

                if (window.currentLetterIndex < word.length) {
                    window.highlightCharIndex = window.currentLetterIndex;

                    cppSpeechProcessor.speak(word.charAt(window.currentLetterIndex));

                    return;
                }

                // Finished letters -> speak whole word
                window.speakingWholeWord = true;
                window.highlightCharIndex = -1;

                console.log("Letters completed. Speaking word:", word);

                cppSpeechProcessor.speak(word);

                return;
            }

            // Whole word completed
            if (window.speakingWholeWord) {
                if (window.repetitionCounter < 3) {
                    window.repetitionCounter++;

                    window.currentLetterIndex = 0;
                    window.speakingWholeWord = false;
                    window.highlightCharIndex = 0;

                    cppSpeechProcessor.speak(word.charAt(0));

                    return;
                }

                console.log("Reading cycle complete.");

                window.highlightCharIndex = -1;

                window.gameState = "listening";
                window.waitingForQuestionTts = true;

                cppSpeechProcessor.speak("So!!!! How do you pronounce this? Its your Turn");

                return;
            }
        }

        // Success feedback completed
        if (window.gameState === "success") {
            if (window.currentWordIndex < wordDatabaseList.count - 1) {
                window.currentWordIndex++;
                window.startGameCycleCurrentWord();
            } else {
                window.gameState = "idle";
            }

            return;
        }

        // Reprompt completed
        if (window.gameState === "comical_reprompt") {
            window.gameState = "listening";
            window.startAudioCapture();
        }
    }

    // function handleTTSFinished() {

    //     // if (window.waitingForQuestionTts) {
    //     //        window.waitingForQuestionTts = false
    //     //        window.startAudioCapture()
    //     //        return
    //     //    }

    //     // if (window.gameState === "welcome") {
    //     //     welcomePauseTimer.start();
    //     // } else if (window.gameState === "reading") {
    //     //     if (window.repetitionCounter < 3) {
    //     //         window.repetitionCounter++;
    //     //         // Slight delay before next spelling track
    //     //         Qt.callLater(window.readWordProgressively);
    //     //     } else {
    //     //         // Ask question
    //     //         // window.gameState = "listening"
    //     //         // cppSpeechProcessor.speak("What is this?")
    //     //         // Qt.callLater(window.startAudioCapture);
    //     //         window.gameState = "listening"
    //     //         window.waitingForQuestionTts = true
    //     //         cppSpeechProcessor.speak("What is this?")
    //     //     }
    //     // }

    //     console.log("TTS finished. Current state:", window.gameState)

    //        // Question prompt has completed, now start listening
    //        if (window.waitingForQuestionTts) {
    //            window.waitingForQuestionTts = false

    //            console.log("Question TTS completed. Starting audio capture.")

    //            window.startAudioCapture()
    //            return
    //        }

    //        // Welcome message completed
    //        if (window.gameState === "welcome") {
    //            console.log("Welcome message finished.")

    //            welcomePauseTimer.start()
    //            return
    //        }

    //        // Reading cycle completed
    //        if (window.gameState === "reading") {

    //            if (window.repetitionCounter < 3) {

    //                window.repetitionCounter++

    //                console.log(
    //                    "Starting repetition " +
    //                    window.repetitionCounter +
    //                    " for word " +
    //                    wordDatabaseList.get(window.currentWordIndex).word
    //                )

    //                Qt.callLater(function() {
    //                    window.readWordProgressively()
    //                })

    //            } else {

    //                console.log("Finished reading word 3 times.")

    //                window.gameState = "listening"
    //                window.waitingForQuestionTts = true

    //                cppSpeechProcessor.speak("What is this?")
    //            }

    //            return
    //        }

    //        // Success feedback finished
    //        if (window.gameState === "success") {

    //            console.log("Success message completed.")

    //            if (window.currentWordIndex < wordDatabaseList.count - 1) {

    //                window.currentWordIndex++
    //                window.startGameCycleCurrentWord()

    //            } else {

    //                console.log("All words completed.")
    //                window.gameState = "idle"
    //            }

    //            return
    //        }

    //        // Comical reprompt finished
    //        if (window.gameState === "comical_reprompt") {

    //            console.log("Reprompt finished. Restarting listening.")

    //            window.gameState = "listening"
    //            window.startAudioCapture()

    //            return
    //        }
    // }

    function startAudioCapture() {
        window.listenCountdown = 5;
        listeningTimer.start();
        window.timeTakenStart = Date.now();
        // Trigger C++ Audio Engine hardware record
        cppSpeechProcessor.startRecording("rec_" + window.childName + "_" + wordDatabaseList.get(currentWordIndex).word);
    }

    function stopAudioCaptureAndAnalyze() {
        var durationMs = Date.now() - window.timeTakenStart;
        var expected = wordDatabaseList.get(currentWordIndex).word;
        // Trigger local Whisper.cpp AI translation and metadata JSON sync inside C++ Thread
        cppSpeechProcessor.stopAndAnalyze(expected, durationMs);
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 25
        columns: 2
        rows: 2

        // TOP ROW: GAME HEADER AND SCORES
        RowLayout {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            spacing: 20

            Text {
                text: "🍀 Steve's QML Word Recognition Lounge"
                font.pixelSize: 24
                font.bold: true
                color: "#1e3a8a"
            }

            // Spacer { Layout.fillWidth: true }

            Rectangle {
                width: 140
                height: 48
                color: "#dbeafe"
                radius: 12
                Text {
                    anchors.centerIn: parent
                    text: "📊 Dashboard"
                    font.bold: true
                    color: "#1e40af"
                }
            }
        }

        // MAIN ARENA LEFT: EMBOSSED GRAPHICAL ALPHABETS
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#ffffff"
            radius: 30
            border.color: "#e2e8f0"
            border.width: 4

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "SPELL THE WORD"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#6366f1"
                    Layout.alignment: Qt.AlignHCenter
                }

                // Colorful Embossed Letters Row (Dual-Sensory highlight synced with Speech boundaries)
                RowLayout {
                    id: lettersRow
                    spacing: 15
                    Layout.alignment: Qt.AlignHCenter

                    Repeater {
                        model: wordDatabaseList.get(window.currentWordIndex).word.length
                        delegate: Rectangle {
                            width: 70
                            height: 70
                            radius: 16
                            color: window.highlightCharIndex === index ? "#fef08a" : "#f1f5f9"
                            border.color: window.highlightCharIndex === index ? "#eab308" : "#94a3b8"
                            border.width: 4
                            scale: window.highlightCharIndex === index ? 1.25 : 1.0

                            Behavior on scale {
                                NumberAnimation {
                                    duration: 150
                                }
                            }
                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: wordDatabaseList.get(window.currentWordIndex).word.charAt(index)
                                font.pixelSize: 42
                                font.bold: true
                                color: "#1e293b"

                                // Embossed shading
                                style: Text.Outline
                                styleColor: "#ffffff"
                            }
                        }
                    }
                }

                Rectangle {
                    width: 250
                    height: 40
                    radius: 20
                    color: window.gameState === "listening" ? "#fee2e2" : "#f0fdf4"
                    Layout.alignment: Qt.AlignHCenter

                    Text {
                        anchors.centerIn: parent
                        text: window.gameState === "listening" ? "🎤 SQUEAKY REC ACTIVE... SPEAK NOW!" : "👂 Ready Steve!"
                        font.bold: true
                        color: window.gameState === "listening" ? "#ef4444" : "#22c55e"
                    }
                }
            }
        }

        // MAIN ARENA RIGHT: COLOURFUL BUT LIGHTWEIGHT CARTOON ART
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#ffffff"
            radius: 30
            border.color: "#e2e8f0"
            border.width: 4

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 15

                // Lightweight Vector Graphics Container
                Item {
                    width: 180
                    height: 180
                    Layout.alignment: Qt.AlignHCenter

                    Rectangle {
                        anchors.fill: parent
                        color: "#f8fafc"
                        radius: 24
                        border.color: "#38bdf8"
                        border.width: 3

                        // Emoji mascot rendering lightweight colorful illustrations
                        Text {
                            anchors.centerIn: parent
                            text: wordDatabaseList.get(window.currentWordIndex).emoji
                            font.pixelSize: 100
                        }
                    }
                }

                Text {
                    text: wordDatabaseList.get(window.currentWordIndex).category.toUpperCase()
                    font.bold: true
                    font.pixelSize: 14
                    color: "#64748b"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // BOTTOM PREV/NEXT CONTROLS BLOCK
        RowLayout {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            spacing: 20

            Button {
                text: "👈 BACK"
                onClicked: {
                    if (window.currentWordIndex > 0) {
                        window.currentWordIndex--;
                        window.startGameCycleCurrentWord();
                    }
                }
            }

            Button {
                text: "🎯 LAUNCH SPEECH CYCLE"
                onClicked: window.startGameCycleCurrentWord()
            }

            Button {
                text: "NEXT WORD 👉"
                onClicked: {
                    if (window.currentWordIndex < wordDatabaseList.count - 1) {
                        window.currentWordIndex++;
                        window.startGameCycleCurrentWord();
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        // Initial setup
        window.startGameCycleCurrentWord();
    }
}

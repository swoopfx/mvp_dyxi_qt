import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CogniMaze

Page {
    id: window
    anchors.fill: parent
    visible: true

    // Initialize our registered C++ cognitive analytics engine
    MazeEngine {
        id: engine
        rows: 6
        cols: 6
        Component.onCompleted: {
            engine.generateNewMaze();
        }

        // onWallCollisionDetected: {
        //     wallSound.play();
        //     collisionFlash.start();
        // }

        // onMazeGenerated: {
        //     timerModel.count = 0;
        //     gameTimer.start();
        // }

        onWallCollisionDetected: {
            engine.playWallCollisionSound();
            collisionFlash.start();
        }

        onMazeGenerated: {
            timerModel.count = 0;
            gameTimer.start();
        }
    }

    // Qt Sound Effects for immediate positive reinforcement
    // SoundEffect {
    //     id: successSound
    //     source: "qrc:/assets/success.wav"
    // }
    // SoundEffect {
    //     id: wallSound
    //     source: "qrc:/assets/wall.wav"
    // }
    // SoundEffect {
    //     id: bubbleSound
    //     source: "qrc:/assets/bubble.wav"
    // }

    // Floating Distraction Component Setup
    property int distRow: 0
    property int distCol: 0
    property bool hasDistraction: false

    Timer {
        id: distractionTimer
        interval: 10000 + Math.random() * 8000
        running: true
        repeat: true
        onTriggered: {
            if (!hasDistraction) {
                // Spawn coordinates
                distRow = Math.floor(Math.random() * engine.rows);
                distCol = Math.floor(Math.random() * engine.cols);
                hasDistraction = true;
                engine.registerDistractionSpawn(distRow, distCol, "Floating Bubble");
            }
        }
    }

    Timer {
        id: gameTimer
        interval: 1000
        repeat: true
        running: true
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 20

        // LEFT COLUMN: Interactive Child-Friendly Game Board
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "🐶 Help puppy reach the star!"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#065F46"
                }
                // Spacer {}
                Label {
                    text: "Focus Index: " + engine.focusIndex + "%"
                    font.bold: true
                    font.pixelSize: 14
                    color: "#047857"
                }
            }

            // High Contrast Grid Layout representation
            Frame {
                Layout.fillWidth: true
                Layout.fillHeight: true
                background: Rectangle {
                    color: "#D1FAE5"
                    border.color: "#065F46"
                    border.width: 3
                    radius: 12
                }

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    rows: engine.rows
                    columns: engine.cols
                    columnSpacing: 6
                    rowSpacing: 6

                    Repeater {
                        model: engine.rows * engine.cols
                        delegate: Rectangle {
                            id: cellRect
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 6

                            // Coordinate mapping indices
                            readonly property int r: Math.floor(index / engine.cols)
                            readonly property int c: index % engine.cols
                            readonly property bool isPlayer: r === engine.playerRow && c === engine.playerCol
                            readonly property bool isGoal: r === (engine.rows - 1) && c === (engine.cols - 1)

                            color: isPlayer ? "#FEF08A" : (isGoal ? "#FDE047" : "#F8FAFC")

                            // Visual border simulation mapping C++ engine wall flags
                            border.color: "#059669"
                            border.width: 1

                            // Custom borders representing maze channels
                            Rectangle {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 3
                                color: "#065F46"
                                visible: engine.mazeReady && engine.checkWall(r, c, "top")
                            }
                            Rectangle {
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right
                                width: 3
                                color: "#065F46"
                                visible: engine.mazeReady && engine.checkWall(r, c, "right")
                            }
                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 3
                                color: "#065F46"
                                visible: engine.mazeReady && engine.checkWall(r, c, "bottom")
                            }
                            Rectangle {
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                width: 3
                                color: "#065F46"
                                visible: engine.mazeReady && engine.checkWall(r, c, "left")
                            }

                            // Puppy emoji rendering
                            Text {
                                text: "🐶"
                                font.pixelSize: 24
                                anchors.centerIn: parent
                                visible: isPlayer

                                Behavior on x {
                                    NumberAnimation {
                                        duration: 150
                                    }
                                }
                                Behavior on y {
                                    NumberAnimation {
                                        duration: 150
                                    }
                                }
                            }

                            // Star goal rendering
                            Text {
                                text: "⭐"
                                font.pixelSize: 22
                                anchors.centerIn: parent
                                visible: isGoal && !isPlayer
                            }

                            // Floating visual Bubble pop target
                            Button {
                                anchors.centerIn: parent
                                width: 28
                                height: 28
                                visible: hasDistraction && r === distRow && c === distCol
                                background: Rectangle {
                                    radius: 14
                                    color: "#F472B6" // Beautiful mild pink bubble
                                    border.color: "#DB2777"
                                    opacity: 0.8
                                }
                                text: "🫧"
                                font.pixelSize: 14

                                onClicked: {
                                    engine.playBubbleSound();
                                    hasDistraction = false;
                                    engine.registerDistractionInteract(true);
                                }
                            }
                        }
                    }
                }
            }

            // Intuitive Pad layout (for easy tablet/touch usage)
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 12
                Button {
                    text: "◀"
                    onClicked: engine.movePlayer("left")
                }
                ColumnLayout {
                    Button {
                        text: "▲"
                        onClicked: engine.movePlayer("top")
                    }
                    Button {
                        text: "▼"
                        onClicked: engine.movePlayer("bottom")
                    }
                }
                Button {
                    text: "▶"
                    onClicked: engine.movePlayer("right")
                }
            }
        }

        // RIGHT COLUMN: C++ Telemetry & Parents Dashboard
        ColumnLayout {
            Layout.preferredWidth: 320
            Layout.fillHeight: true
            spacing: 14

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#1E293B"
                radius: 12
                border.color: "#334155"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    Label {
                        text: "Therapists Metrics Panel"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 16
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#475569"
                    }

                    // Metrics lines
                    Label {
                        text: "Wall Incursions: " + engine.wallCollisions
                        color: "#94A3B8"
                        font.pixelSize: 12
                    }
                    Label {
                        text: "Path Backtracks: " + engine.backtracksCount
                        color: "#94A3B8"
                        font.pixelSize: 12
                    }
                    Label {
                        text: "Overall Focus: " + engine.focusIndex + "%"
                        color: "#34D399"
                        font.bold: true
                        font.pixelSize: 13
                    }

                    // Spacer {}

                    Button {
                        Layout.fillWidth: true
                        text: "Sync Secure Telemetry"
                        onClicked: {
                            engine.triggerDataSync("https://api.cognimaze-clinic.com/v1/telemetry");
                        }
                    }

                    Label {
                        text: engine.isSyncing ? "Syncing data to AWS/GCP (C++)..." : "State: Ready to transmit"
                        color: "#A1A1AA"
                        font.pixelSize: 10
                    }
                }
            }
        }
    }

    // Flash animation to indicate boundary bump without noisy jarring audio
    // ColorAnimation {
    //     id: collisionFlash
    //     target: window
    //     property: "color"
    //     from: "#FEE2E2" // Subtle rose tint
    //     to: "#F0FDF4"
    //     duration: 250
    // }
    Rectangle {
        id: flashLayer
        anchors.fill: parent
        color: "transparent"
        z: -1
    }
    ColorAnimation {
        id: collisionFlash
        target: flashLayer
        property: "color"
        from: "#FEE2E2"
        to: "transparent"
        duration: 250
    }

    Connections {
        target: engine

        function onMazeCompleted() {
            engine.playSuccessSound();
            gameTimer.stop();
            //Sow success confetti
            //wait for some second then redirect to previous page
            completedDialog.open();
        }
    }
}

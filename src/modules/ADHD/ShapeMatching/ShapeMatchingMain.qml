import QtQuick 2.15
import QtQuick.Controls 2.15
import ShapeMatching

ApplicationWindow {
    id: window
    width: 1024
    height: 768
    visible: true
    title: "Children Shape Matcher (C++ & QML Modular Engine)"

    // Custom Palette to match React App
    property color bgGradStart: "#F0F4F8"
    property color bgGradEnd: "#DDE3EA"
    property color cardBg: "#FFFFFF"
    property color textDark: "#1E293B"
    property color textMuted: "#64748B"
    property color accentMatch: "#10B981"
    property color accentFail: "#EF4444"

    // Active Difficulty selection: easy, medium, hard
    property string activeDifficulty: "medium"
    property real totalGameTime: 0.0

    // Instantiate C++ Telemetry Controller
    TelemetryBackend {
        id: backend
        onMatchSuccessToast: {
            toastLabel.text = "🎉 MATCHED: " + shapeName + "!";
            toastNotification.restartToast();
            backend.playCorrect();
        }
        onMatchFailToast: {
            toastLabel.text = "❌ Try again for " + shapeName + "!";
            toastNotification.restartToast();
            backend.playFail();
        }
    }

    // Outer background layout
    Rectangle {
        id: bgContainer
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: bgGradStart
            }
            GradientStop {
                position: 1.0
                color: bgGradEnd
            }
        }

        // Sky background clouds floating
        Image {
            id: floatingCloud
            source: "assets/cloud.svg"
            width: 130
            height: 80
            opacity: 0.5
            x: 80
            y: 40
            SequentialAnimation on x {
                loops: Animation.Infinite
                NumberAnimation {
                    to: window.width + 150
                    duration: 28000
                    easing.type: Easing.Linear
                }
                NumberAnimation {
                    from: -150
                    to: 80
                    duration: 0
                }
            }
        }

        // Top Navigation and Header Controls Bar
        Rectangle {
            id: headerHud
            width: parent.width - 40
            height: 75
            radius: 16
            color: "#E6FFFFFF"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 15
            border.color: "#FFFFFF"
            border.width: 1

            Row {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 20
                verticalAlignment: TextInput.AlignVCenter

                Text {
                    text: "✨ Shape Matcher C++ backend"
                    font.pixelSize: 18
                    font.bold: true
                    color: textDark
                }

                Item {
                    width: 10
                    height: 1
                } // spacer

                // Age Category selector buttons
                Row {
                    spacing: 6
                    Text {
                        text: "Difficulty:"
                        color: textMuted
                        font.pixelSize: 12
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Button {
                        text: "Easy (Ages 4-6)"
                        onClicked: {
                            activeDifficulty = "easy";
                            backend.resetTelemetry();
                        }
                        background: Rectangle {
                            color: activeDifficulty === "easy" ? "#F59E0B" : "#F1F5F9"
                            radius: 8
                        }
                    }

                    Button {
                        text: "Medium (Ages 7-9)"
                        onClicked: {
                            activeDifficulty = "medium";
                            backend.resetTelemetry();
                        }
                        background: Rectangle {
                            color: activeDifficulty === "medium" ? "#2563EB" : "#F1F5F9"
                            radius: 8
                        }
                    }

                    Button {
                        text: "Hard (Ages 10-13)"
                        onClicked: {
                            activeDifficulty = "hard";
                            backend.resetTelemetry();
                        }
                        background: Rectangle {
                            color: activeDifficulty === "hard" ? "#7C3AED" : "#F1F5F9"
                            radius: 8
                        }
                    }
                }

                Item {
                    width: 10
                    height: 1
                    layoutFrame: true
                } // spacer

                Text {
                    text: "Time: " + totalGameTime.toFixed(1) + "s"
                    font.pixelSize: 15
                    font.family: "Courier"
                    font.bold: true
                    color: textDark
                }
            }
        }

        // Primary Grid split: Left (Game Arena renderers), Right (C++ heavy telemetry indices)
        Row {
            anchors.top: headerHud.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20
            spacing: 20

            // GAME ARENA: Dynamically loads the specific Page Renderable based on difficulty
            Rectangle {
                width: parent.width * 0.58
                height: parent.height - 30
                color: "#90FFFFFF"
                radius: 20
                border.color: "#E2E8F0"
                clip: true

                Loader {
                    id: difficultyPageLoader
                    anchors.fill: parent
                    anchors.margins: 10
                    source: activeDifficulty === "easy" ? "EasyPage.qml" : (activeDifficulty === "medium" ? "MediumPage.qml" : "HardPage.qml")
                }
            }

            // REAL-TIME C++ TELEMETRY DASHBOARD (Right Column panel)
            Rectangle {
                width: parent.width * 0.40
                height: parent.height - 30
                color: "#1E293B" // Deep professional navy slate
                radius: 20
                border.color: "#334155"

                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 12

                    Text {
                        text: "📊 Performance Telemetry Engine (C++ Computed)"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#F8FAFC"
                    }

                    // Derived Indexes calculated inside C++ backend directly
                    Row {
                        width: parent.width
                        spacing: 8

                        Rectangle {
                            width: (parent.width - 16) / 3
                            height: 65
                            radius: 10
                            color: "#0F172A"
                            Column {
                                anchors.centerIn: parent
                                spacing: 2
                                Text {
                                    text: "CREATIVE IDX"
                                    color: "#94A3B8"
                                    font.pixelSize: 8
                                    font.bold: true
                                }
                                Text {
                                    text: backend.creativeIndex.toFixed(0)
                                    color: "#38BDF8"
                                    font.pixelSize: 16
                                    font.bold: true
                                }
                            }
                        }
                        Rectangle {
                            width: (parent.width - 16) / 3
                            height: 65
                            radius: 10
                            color: "#0F172A"
                            Column {
                                anchors.centerIn: parent
                                spacing: 2
                                Text {
                                    text: "SOLVING IDX"
                                    color: "#94A3B8"
                                    font.pixelSize: 8
                                    font.bold: true
                                }
                                Text {
                                    text: backend.problemSolvingIndex.toFixed(0)
                                    color: "#4ADE80"
                                    font.pixelSize: 16
                                    font.bold: true
                                }
                            }
                        }
                        Rectangle {
                            width: (parent.width - 16) / 3
                            height: 65
                            radius: 10
                            color: "#0F172A"
                            Column {
                                anchors.centerIn: parent
                                spacing: 2
                                Text {
                                    text: "SPEED SCORE"
                                    color: "#94A3B8"
                                    font.pixelSize: 8
                                    font.bold: true
                                }
                                Text {
                                    text: backend.speedIndex.toFixed(0)
                                    color: "#FBBF24"
                                    font.pixelSize: 16
                                    font.bold: true
                                }
                            }
                        }
                    }

                    // Basic summary stats
                    Grid {
                        columns: 2
                        spacing: 10
                        width: parent.width

                        Text {
                            text: "Total Match Attempts: " + backend.totalTries
                            color: "#94A3B8"
                            font.pixelSize: 11
                        }
                        Text {
                            text: "Matches Completed: " + backend.totalCorrect
                            color: "#4ADE80"
                            font.pixelSize: 11
                            font.bold: true
                        }
                        Text {
                            text: "Avg Correct Match Solving Speed: " + (backend.averageCorrectTime / 1000.0).toFixed(2) + "s"
                            color: "#FBBF24"
                            font.pixelSize: 11
                        }
                        Text {
                            text: "Avg Failed Attempts: " + backend.totalFailed
                            color: "#F87171"
                            font.pixelSize: 11
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#334155"
                    }

                    Button {
                        width: parent.width
                        height: 40
                        text: "Export C++ JSON Telemetry Package"
                        onClicked: {
                            exportTextArea.text = backend.getTelemetryJson();
                        }
                    }

                    ScrollView {
                        width: parent.width
                        height: parent.height - 240
                        clip: true

                        TextArea {
                            id: exportTextArea
                            placeholderText: "{ ... Computed JSON Telemetry from C++ will show here ... }"
                            font.family: "Courier"
                            font.pixelSize: 10
                            color: "#38BDF8"
                            background: Rectangle {
                                color: "#0F172A"
                                radius: 10
                            }
                            wrapMode: TextEdit.Wrap
                            readOnly: true
                        }
                    }
                }
            }
        }
    }

    // Active Global Mouse tracker for swipes and pointer motion events
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        property qreal startX: 0
        property qreal startY: 0
        property real pressTime: 0

        onPressed: {
            mouse.accepted = false;
            startX = mouse.x;
            startY = mouse.y;
            pressTime = totalGameTime;
            backend.playSelect();
        }

        onReleased: {
            mouse.accepted = false;
            var duration = (totalGameTime - pressTime) * 1000;
            var deltaX = mouse.x - startX;
            var deltaY = mouse.y - startY;
            var dir = "None";
            var dist = Math.sqrt(deltaX * deltaX + deltaY * deltaY);

            if (dist > 30) {
                if (Math.abs(deltaX) > Math.abs(deltaY)) {
                    dir = deltaX > 0 ? "Right" : "Left";
                } else {
                    dir = deltaY > 0 ? "Down" : "Up";
                }
            }
            backend.logPress(duration, dir, dist);
        }
    }

    // Game duration timer tick
    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: totalGameTime += 0.1
    }

    // Interactive Toast Notification bar
    Rectangle {
        id: toastNotification
        width: 250
        height: 50
        radius: 12
        color: "#CC0F172A"
        border.color: "#38BDF8"
        border.width: 1.5
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: -60
        opacity: 0.0

        Text {
            id: toastLabel
            anchors.centerIn: parent
            color: "#FFF"
            font.bold: true
            font.pixelSize: 12
        }

        function restartToast() {
            toastFadeIn.restart();
            toastDismissTimer.restart();
        }

        PropertyAnimation {
            id: toastFadeIn
            target: toastNotification
            properties: "opacity,anchors.bottomMargin"
            to: 1.0
            duration: 350
        }

        Timer {
            id: toastDismissTimer
            interval: 2200
            onTriggered: toastFadeOut.start()
        }

        PropertyAnimation {
            id: toastFadeOut
            target: toastNotification
            properties: "opacity,anchors.bottomMargin"
            to: 0.0
            duration: 350
        }
    }
}

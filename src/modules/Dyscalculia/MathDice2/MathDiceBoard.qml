/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: diceBoardRoot
    property var appRoot: null

    property string difficulty: "Junior"
    property int diceSum: 0
    property int targetNumber: 10
    property var rolledDice: [4, 2, 5]
    property string activeEquation: ""
    property string feedbackMessage: "Select numbers & math operators to target: " + targetNumber
    property string feedbackColor: "#2D3436"

    function initProblem() {
        var d1 = nativeRng.rollDice(6);
        var d2 = nativeRng.rollDice(6);
        var d3 = nativeRng.rollDice(6);
        rolledDice = [d1, d2, d3];

        activeEquation = "";

        if (difficulty === "Junior") {
            targetNumber = d1 + d2;
            feedbackMessage = "Roll and combine dice with '+' or '-' to reach: " + targetNumber;
        } else if (difficulty === "Apprentice") {
            targetNumber = d1 * d2 + d3;
            feedbackMessage = "Roll and combine dice using '+', '-' or '*' to make: " + targetNumber;
        } else {
            targetNumber = (d1 + d2) * d3;
            feedbackMessage = "Create complex parenthesized wizards structures to form: " + targetNumber;
        }

        if (appRoot) {
            appRoot.logTelemetryEvent("dice_rolled", difficulty, "New puzzle rolled! Dice: " + d1 + ", " + d2 + ", " + d3 + ". Target: " + targetNumber);
        }
    }

    Component.onCompleted: {
        initProblem()
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        ColumnLayout {
            width: parent.width - 24
            spacing: 20

            // 1. Level selector Panel
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                color: "white"
                radius: 18
                border.color: "#2D3436"
                border.width: 3

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 12

                    Text {
                        text: "SELECT LEVEL: "
                        font.bold: true
                        font.pixelSize: 12
                        color: "#2D3436"
                    }

                    Row {
                        spacing: 8
                        Button {
                            text: "Junior ✅"
                            highlighted: difficulty === "Junior"
                            onClicked: { difficulty = "Junior"; initProblem(); }
                        }
                        Button {
                            text: "Apprentice ⚡"
                            highlighted: difficulty === "Apprentice"
                            onClicked: { difficulty = "Apprentice"; initProblem(); }
                        }
                        Button {
                            text: "Wizard 🧙"
                            highlighted: difficulty === "Wizard"
                            onClicked: { difficulty = "Wizard"; initProblem(); }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Button {
                        text: "🔄 Re-Roll Dice!"
                        font.bold: true
                        onClicked: initProblem()
                    }
                }
            }

            // 2. Play Board visual panel
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                color: "#FFFAF0"
                radius: 24
                border.color: "#2D3436"
                border.width: 4

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15

                    Text {
                        text: "MATCH TARGET NUMBER:"
                        font.bold: true
                        font.pixelSize: 11
                        color: "#636E72"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: targetNumber.toString()
                        font.pixelSize: 56
                        font.bold: true
                        color: "#FF6B6B"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    // Dice Row
                    Row {
                        spacing: 15
                        Layout.alignment: Qt.AlignHCenter

                        Repeater {
                            model: rolledDice.length
                            delegate: Button {
                                width: 70
                                height: 70
                                bottomPadding: 4
                                leftPadding: 4
                                onClicked: {
                                    activeEquation += " " + rolledDice[modelData] + " "
                                }

                                contentItem: Column {
                                    spacing: 2
                                    anchors.centerIn: parent
                                    Text {
                                        text: "🎲"
                                        font.pixelSize: 22
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Text {
                                        text: "VALUE: " + rolledDice[modelData]
                                        font.pixelSize: 11
                                        font.bold: true
                                        color: "#2D3436"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // 3. User Input & Math builders
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 180
                color: "white"
                radius: 18
                border.color: "#2D3436"
                border.width: 3

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 10

                    RowLayout {
                        spacing: 6
                        Layout.fillWidth: true

                        Button { text: "+"; font.bold: true; onClicked: activeEquation += " + " }
                        Button { text: "-"; font.bold: true; onClicked: activeEquation += " - " }
                        Button { text: "*"; font.bold: true; onClicked: activeEquation += " * " }
                        Button { text: "/"; font.bold: true; onClicked: activeEquation += " / " }
                        Button { text: "("; font.bold: true; onClicked: activeEquation += " ( " }
                        Button { text: ")"; font.bold: true; onClicked: activeEquation += " ) " }

                        Item { Layout.fillWidth: true }

                        Button {
                            text: "💥 Clear"
                            onClicked: activeEquation = ""
                        }
                    }

                    TextField {
                        id: equationTextEdit
                        Layout.fillWidth: true
                        text: activeEquation
                        placeholderText: "Enter equation utilizing above numbers..."
                        font.pixelSize: 16
                        font.bold: true
                        color: "#2D3436"
                        onTextChanged: activeEquation = text
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: feedbackMessage
                            font.bold: true
                            font.pixelSize: 11
                            color: feedbackColor
                            Layout.fillWidth: true
                        }

                        Button {
                            text: "CHECK SUBMISSION! ➔"
                            font.bold: true
                            highlighted: true
                            onClicked: {
                                // Dynamic formula evaluations in pure expressions QML
                                try {
                                    var cleaned = activeEquation;
                                    var calculated = eval(cleaned);
                                    if (calculated === targetNumber) {
                                        feedbackColor = "#2bc4c3";
                                        feedbackMessage = "Correct answer! Beautiful math solving!";
                                        if (appRoot) {
                                            appRoot.userPoints += 100;
                                            appRoot.logTelemetryEvent("submit_attempt", difficulty, "SUCCESS! Clean formula solved: " + cleaned + " = " + calculated);
                                        }
                                        initProblem();
                                    } else {
                                        feedbackColor = "#FF6B6B";
                                        feedbackMessage = "Equaled " + calculated + " instead of " + targetNumber + ". Try again!";
                                        if (appRoot) {
                                            appRoot.logTelemetryEvent("submit_attempt", difficulty, "FAILURE: Submitted: " + cleaned + " -> yielded : " + calculated);
                                        }
                                    }
                                } catch(e) {
                                    feedbackColor = "#E67E22";
                                    feedbackMessage = "Math format mismatch! Ensure operators are placed correctly.";
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

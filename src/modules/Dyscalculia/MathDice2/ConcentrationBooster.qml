/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: boosterViewRoot
    property var appRoot: null

    property bool trainingActive: false
    property int matchesFound: 0
    property int boosterTimer: 30
    property int movesCount: 0
    property var currentCards: []
    property int firstFlippedIndex: -1
    property int secondFlippedIndex: -1

    Timer {
        id: countdownTimer
        interval: 1000
        repeat: true
        running: trainingActive && boosterTimer > 0
        onTriggered: {
            boosterTimer--;
            if (boosterTimer <= 0) {
                trainingActive = false;
                if (appRoot) {
                    appRoot.logTelemetryEvent("complementary_timeout", "Junior", "Focused Booster timed out. Training expired.");
                }
            }
        }
    }

    function startTraining() {
        trainingActive = true;
        matchesFound = 0;
        boosterTimer = 45;
        movesCount = 0;
        firstFlippedIndex = -1;
        secondFlippedIndex = -1;

        // Dynamic card values creation (4 equations + 4 matching dot counts)
        // IDs: equation cards (idx 0 to 3) match values (idx 4 to 7)
        var raw = [
            {"id": 0, "type": "equation", "matchVal": 5, "label": "2 + 3", "shown": false, "cleared": false},
            {"id": 1, "type": "equation", "matchVal": 6, "label": "2 * 3", "shown": false, "cleared": false},
            {"id": 2, "type": "equation", "matchVal": 4, "label": "8 / 2", "shown": false, "cleared": false},
            {"id": 3, "type": "equation", "matchVal": 2, "label": "5 - 3", "shown": false, "cleared": false},
            {"id": 4, "type": "dots", "matchVal": 5, "label": "● ● ● ● ●", "shown": false, "cleared": false},
            {"id": 5, "type": "dots", "matchVal": 6, "label": "● ● ●\n● ● ●", "shown": false, "cleared": false},
            {"id": 6, "type": "dots", "matchVal": 4, "label": "● ●\n● ●", "shown": false, "cleared": false},
            {"id": 7, "type": "dots", "matchVal": 2, "label": "● ●", "shown": false, "cleared": false}
        ];

        // Shuffle arrays in-browser QML JS
        for (var i = raw.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var temp = raw[i];
            raw[i] = raw[j];
            raw[j] = temp;
        }

        currentCards = raw;
        if (appRoot) {
            appRoot.logTelemetryEvent("complementary_start", "Junior", "Launched Focused Subitizing Trainer.");
        }
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        ColumnLayout {
            width: parent.width - 24
            spacing: 20

            // 1. Header controls
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                color: "white"
                radius: 18
                border.color: "#2D3436"
                border.width: 3

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 12

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text {
                            text: "🧠 SUBITIZING BOOSTERS"
                            font.bold: true
                            font.pixelSize: 14
                            color: "#2D3436"
                        }
                        Text {
                            text: "Flip cards and pair formulas with equivalent dots to earn points!"
                            font.pixelSize: 10
                            color: "#636E72"
                        }
                    }

                    Row {
                        spacing: 12
                        visible: trainingActive
                        Text {
                            text: "⏳ Time: " + boosterTimer + "s"
                            font.bold: true
                            font.pixelSize: 12
                            font.family: "Monospace"
                            color: "#E67E22"
                        }
                        Text {
                            text: "Pairs Matched: " + matchesFound + " / 4"
                            font.bold: true
                            font.pixelSize: 12
                            font.family: "Monospace"
                            color: "#4834DF"
                        }
                    }

                    Button {
                        text: trainingActive ? "Restart Trainer" : "Launch Match!"
                        highlighted: !trainingActive
                        onClicked: startTraining()
                    }
                }
            }

            // 2. Play Board Canvas area
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 380
                color: "#FFF9F2"
                radius: 24
                border.color: "#2D3436"
                border.width: 4

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    // Waiting Screen
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: !trainingActive
                        spacing: 10
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            text: "🧠"
                            font.pixelSize: 52
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Text {
                            text: "Match Equations & Quantity Dots"
                            font.bold: true
                            font.pixelSize: 14
                            color: "#2D3436"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Text {
                            text: "Activates physical layout identification speed mechanisms in high-fluid brains."
                            font.pixelSize: 11
                            color: "#636E72"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Button {
                            text: "Launch Active Solver Game"
                            Layout.alignment: Qt.AlignHCenter
                            onClicked: startTraining()
                        }
                    }

                    // Active Game
                    GridLayout {
                        id: memoryGrid
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: trainingActive
                        columns: 4
                        rows: 2
                        rowSpacing: 10
                        columnSpacing: 10

                        Repeater {
                            model: currentCards.length
                            delegate: Button {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                flat: true
                                
                                property var card: currentCards[modelData]
                                property bool isFlipped: card.shown || card.cleared

                                onClicked: {
                                    if (card.cleared || card.shown) return;
                                    if (firstFlippedIndex !== -1 && secondFlippedIndex !== -1) return;

                                    card.shown = true;
                                    var updatedList = currentCards;
                                    updatedList[modelData] = card;
                                    currentCardsChanged(); // trigger view sync

                                    if (firstFlippedIndex === -1) {
                                        firstFlippedIndex = modelData;
                                    } else {
                                        secondFlippedIndex = modelData;
                                        movesCount++;
                                        
                                        // Evaluate match after brief timer
                                        matchTimeout.start();
                                    }
                                }

                                contentItem: Rectangle {
                                    anchors.fill: parent
                                    color: card.cleared ? "#e3fafc" : card.shown ? (card.type === "equation" ? "#A29BFE" : "#55E6C1") : "#ffffff"
                                    radius: 12
                                    border.color: "#2D3436"
                                    border.width: 3

                                    Text {
                                        text: card.shown || card.cleared ? (card.label) : "?"
                                        font.bold: true
                                        font.pixelSize: (card.shown || card.cleared) ? 14 : 22
                                        color: "#2D3436"
                                        anchors.centerIn: parent
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: matchTimeout
        interval: 800
        repeat: false
        onTriggered: {
            var first = currentCards[firstFlippedIndex];
            var second = currentCards[secondFlippedIndex];

            if (first.matchVal === second.matchVal && first.type !== second.type) {
                first.cleared = true;
                second.cleared = true;
                matchesFound++;

                if (matchesFound === 4) {
                    trainingActive = false;
                    if (appRoot) {
                        appRoot.userPoints += 150;
                        appRoot.logTelemetryEvent("complementary_success", "Junior", "Memory focus completed in " + movesCount + " moves! Graded perfect match.");
                    }
                }
            } else {
                first.shown = false;
                second.shown = false;
            }

            var updatedList = currentCards;
            updatedList[firstFlippedIndex] = first;
            updatedList[secondFlippedIndex] = second;
            currentCards = updatedList;
            currentCardsChanged();

            firstFlippedIndex = -1;
            secondFlippedIndex = -1;
        }
    }
}

/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MathDice2

Page {
    id: qmlAppRoot
    // width: 1024
    // height: 768
    // minimumWidth: 800
    // minimumHeight: 600
    anchors.fill: parent
    visible: true
    title: qsTr("Math Dice Master — Pure Qt6 Engine")

    property string primaryColor: "#2D3436"
    property string highlightColor: "#4834DF"
    property string accentColor: "#FF6B6B"
    property string yellowColor: "#F9CA24"
    property string creamBg: "#FFFAF0"

    property int userPoints: 0
    property var telemetryLogsList: []

    // Single instantiation of C++ MT19937 randomizer
    MersenneTwister {
        id: nativeRng
    }

    // High quality audio triggers (simulated via standard system sound files)
    Component.onCompleted: {
        logTelemetryEvent("game_start", "Junior", "Math Dice Master arena booted in Qt6 environment.")
    }

    function logTelemetryEvent(eventType, difficulty, message) {
        var eventLog = {
            "timestamp": new Date().toLocaleTimeString(),
            "eventType": eventType,
            "difficulty": difficulty,
            "details": message
        }
        var newArray = telemetryLogsList
        newArray.push(eventLog)
        telemetryLogsList = newArray
        telemetryLogsChanged() // trigger notifications
    }

    // Core Theme Background Paint
    Rectangle {
        anchors.fill: parent
        color: creamBg

        // Visual gradients corresponding to the React version
        Rectangle {
            width: 500
            height: 500
            radius: 250
            color: "#F9CA24"
            opacity: 0.05
            anchors.right: parent.right
            anchors.top: parent.top
            z: 0
        }
        Rectangle {
            width: 600
            height: 600
            radius: 300
            color: "#6C5CE7"
            opacity: 0.05
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            z: 0
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15
            z: 1

            // 1. Primary Navigation Shell
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 90
                color: "white"
                radius: 24
                border.color: primaryColor
                border.width: 4

                // Neobrutalist shadow effect
                Rectangle {
                    anchors.fill: parent
                    color: primaryColor
                    radius: 24
                    z: -1
                    anchors.leftMargin: 4
                    anchors.topMargin: 4
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    Row {
                        spacing: 12
                        Layout.alignment: Qt.AlignVCenter

                        Rectangle {
                            width: 50
                            height: 50
                            color: accentColor
                            radius: 12
                            border.color: primaryColor
                            border.width: 3
                            rotation: 3

                            Text {
                                text: "🎲"
                                font.pixelSize: 24
                                anchors.centerIn: parent
                            }
                        }

                        Column {
                            spacing: 2
                            Text {
                                text: "MATH DICE <b>MASTER</b>"
                                font.pixelSize: 20
                                font.bold: true
                                color: primaryColor
                            }
                            Text {
                                text: "MT19937 READY — CHILD MATH TRAINING"
                                font.pixelSize: 10
                                font.bold: true
                                color: "#636E72"
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Navigation bar tabs inside a RowLayout
                    Row {
                        spacing: 8
                        Layout.alignment: Qt.AlignVCenter

                        Button {
                            text: "🎯 Direct Play"
                            flat: true
                            font.bold: true
                            highlighted: mainTabsStack.currentIndex === 0
                            onClicked: mainTabsStack.currentIndex = 0
                        }
                        Button {
                            text: "🧠 Focus Booster"
                            flat: true
                            font.bold: true
                            highlighted: mainTabsStack.currentIndex === 1
                            onClicked: mainTabsStack.currentIndex = 1
                        }
                        Button {
                            text: "📊 Performance"
                            flat: true
                            font.bold: true
                            highlighted: mainTabsStack.currentIndex === 2
                            onClicked: mainTabsStack.currentIndex = 2
                        }
                    }

                    Rectangle {
                        color: "#6C5CE7"
                        radius: 18
                        border.color: primaryColor
                        border.width: 2
                        width: 140
                        height: 48
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            text: "SCORE: <b>" + userPoints + "</b>"
                            color: "white"
                            font.pixelSize: 14
                            font.bold: true
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            // 2. Play Content Loader
            StackLayout {
                id: mainTabsStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: 0

                MathDiceBoard {
                    id: boardView
                    appRoot: qmlAppRoot
                }

                ConcentrationBooster {
                    id: boosterView
                    appRoot: qmlAppRoot
                }

                CognitiveDashboard {
                    id: diagnosticsView
                    appRoot: qmlAppRoot
                }
            }
        }
    }
}

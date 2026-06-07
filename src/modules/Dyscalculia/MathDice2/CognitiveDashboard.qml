/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: diagnosticsDashboardRoot
    property var appRoot: null

    ScrollView {
        anchors.fill: parent
        clip: true

        ColumnLayout {
            width: parent.width - 24
            spacing: 20

            // 1. Core Speed and Accuracy Metrics Cards
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 12
                columnSpacing: 12

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    color: "white"
                    radius: 18
                    border.color: "#2D3436"
                    border.width: 3

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 2

                        Text {
                            text: "ACCURACY RATING"
                            font.bold: true
                            font.pixelSize: 10
                            color: "#636E72"
                        }
                        Text {
                            text: "100%"
                            font.pixelSize: 28
                            font.bold: true
                            color: "#FF6B6B"
                        }
                        Text {
                            text: "Calculated based on active equations."
                            font.pixelSize: 10
                            color: "#2D3436"
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    color: "white"
                    radius: 18
                    border.color: "#2D3436"
                    border.width: 3

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 2

                        Text {
                            text: "CONCENTRATION SCORE"
                            font.bold: true
                            font.pixelSize: 10
                            color: "#636E72"
                        }
                        Text {
                            text: "90/100"
                            font.pixelSize: 28
                            font.bold: true
                            color: "#6C5CE7"
                        }
                        Text {
                            text: "Based on speed matching consistency."
                            font.pixelSize: 10
                            color: "#2D3436"
                        }
                    }
                }
            }

            // 2. Real-time logging viewer and streams
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 380
                color: "white"
                radius: 20
                border.color: "#2D3436"
                border.width: 3

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 12

                    RowLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Text {
                            text: "📋 ACTIVE TELEMETRY ACTION STRIP"
                            font.bold: true
                            font.pixelSize: 13
                            color: "#2D3436"
                        }

                        Item { Layout.fillWidth: true }

                        Button {
                            text: "🗑 Clear Stream logs"
                            onClicked: {
                                if (appRoot) {
                                    appRoot.telemetryLogsList = [];
                                    appRoot.logTelemetryEvent("game_cleared", "Junior", "User cleared active memory storage stream.");
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#2D3436"
                        radius: 12
                        border.color: "#212529"
                        border.width: 1

                        ListView {
                            id: logListView
                            anchors.fill: parent
                            anchors.margins: 12
                            clip: true
                            model: appRoot ? appRoot.telemetryLogsList : []
                            spacing: 8

                            delegate: Rectangle {
                                width: logListView.width
                                height: 55
                                color: "#3a4446"
                                radius: 8

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 10

                                    Rectangle {
                                        width: 80
                                        height: 28
                                        color: "#F9CA24"
                                        radius: 4
                                        Text {
                                            text: modelData.eventType.toUpperCase()
                                            font.bold: true
                                            font.pixelSize: 8
                                            color: "#2D3436"
                                            anchors.centerIn: parent
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2
                                        Text {
                                            text: modelData.details
                                            font.bold: true
                                            font.pixelSize: 10
                                            color: "white"
                                        }
                                        Text {
                                            text: "Time index: " + modelData.timestamp + " | Mode: " + modelData.difficulty
                                            font.pixelSize: 8
                                            color: "#b2bec3"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

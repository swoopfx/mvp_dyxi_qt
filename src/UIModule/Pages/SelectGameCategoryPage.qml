import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "../Components"
import General
import Recognition
import Writing
import MathDice2

Page {
    id: selectGamePage
    property string activeUserName: ""
    property string userAge: ""
    property var gameTypeId: ""

    // property var gameTypeId: {}
    // anchors.fill: parent

    CoreSettings {
        id: coreSettings
    }

    NetworkAccessPresets {
        id: networkPresets
    }

    Image {
        id: bg_image
        source: "qrc:/ui/images/playground.jpg"
        fillMode: Image.PreserveAspectCrop
        mipmap: true
        smooth: true
        anchors.fill: parent
    }

    Column {
        anchors.fill: parent
        anchors.margins: 40
        anchors.centerIn: parent
        spacing: 40

        // Header
        // Rectangle {
        //     width: parent.width
        //     height: 60
        //     color: "white"
        //     radius: 60
        //     border.color: "#AED581"
        //     border.width: 5

        //     Text {
        //         anchors.centerIn: parent
        //         text: "Dyxi Learning World"
        //         color: "#558B2F"
        //         font.family: "Verdana", "Arial"
        //         font.pixelSize: 12
        //         font.bold: true
        //         // letterSpacing: 2
        //     }
        // }

        // contentHeight:

        ScrollView {
            anchors.fill: parent

            Flickable {
                id: flick
                anchors.fill: parent
                contentHeight: contentColumn.implicitHeight
                clip: true

                Column {
                    id: contentColumn
                    width: flick.width
                    spacing: 20

                    // =========================
                    // Literacy Games
                    // =========================
                    Rectangle {
                        width: parent.width
                        height: 50
                        radius: 10
                        color: "#E8F5E9"

                        Text {
                            anchors.centerIn: parent
                            text: "📚 Game type"
                            font.pixelSize: 22
                            font.bold: true
                            color: "#2E7D32"
                        }
                    }

                    // First section
                    GridLayout {
                        id: gridTop
                        width: parent.width
                        // columns: 4
                        columnSpacing: 15
                        rowSpacing: 15

                        GameItem {
                            labelText: "Phonics Fun"
                            imageSource: "qrc:/ui/images/phonics.png"
                            onClicked: stackView.push("GameLoaderPage.qml", {
                                // "url": coreSettings.baseUrl+"/api/game-by-type"+"?type=1"+"age"+UserSession.userAge,
                                "url": coreSettings.dyxiGetGameList + "?type=" + gameTypeId[0].id,
                                "pageTitle": selectGamePage.gameTypeId[0].type,
                                "avatar": "qrc:/ui/images/phonics.png",
                                "resoucesUrl": selectGamePage.gameTypeId[0].type,
                                "stackView": stackView
                            })
                        }

                        GameItem {
                            labelText: "Word Tracing"
                            imageSource: "qrc:/ui/images/tracing.png"
                            onClicked: stackView.push("GameLoaderPage.qml", {
                                "url": coreSettings.dyxiGetGameList + "?type=" + gameTypeId[2].id,
                                "pageTitle": selectGamePage.gameTypeId[2].type,
                                "avatar": "qrc:/ui/images/phonics.png",
                                "resoucesUrl": selectGamePage.gameTypeId[2].type,
                                "stackView": stackView
                            })
                        }

                        GameItem {
                            labelText: "Recognition"
                            imageSource: "qrc:/ui/images/recognition.png"
                            onClicked: stackView.push("GameLoaderPage.qml", {
                                "url": coreSettings.dyxiGetGameList + "?type=" + gameTypeId[2].id,
                                "pageTitle": selectGamePage.gameTypeId[2].type,
                                "avatar": "qrc:/ui/images/phonics.png",
                                "resoucesUrl": selectGamePage.gameTypeId[2].type,
                                "stackView": stackView
                            })
                        }

                        GameItem {
                            labelText: "Reading"
                            imageSource: "qrc:/ui/images/reading.png"
                            onClicked: stackView.push("GameLoaderPage.qml", {
                                "url": coreSettings.dyxiGetGameList + "?type=" + gameTypeId[2].id,
                                "pageTitle": selectGamePage.gameTypeId[2].type,
                                "avatar": "qrc:/ui/images/phonics.png",
                                "resoucesUrl": selectGamePage.gameTypeId[2].type
                            })
                        }
                    }

                    // Horizontal spacer / divider
                    Rectangle {
                        width: parent.width
                        height: 3
                        color: "#38bdf8"
                        opacity: 0.4
                    }

                    // =========================
                    // Literacy Games
                    // =========================
                    Rectangle {
                        width: parent.width
                        height: 50
                        radius: 10
                        color: "#E8F5E9"

                        Text {
                            anchors.centerIn: parent
                            text: "🧠 Choose mode"
                            font.pixelSize: 22
                            font.bold: true
                            color: "#2E7D32"
                        }
                    }

                    // Second section
                    GridLayout {
                        id: gridBottom
                        width: parent.width
                        // columns: 4
                        columnSpacing: 20
                        rowSpacing: 20

                        GameItem {
                            labelText: "Writing Practice"
                            imageSource: "qrc:/ui/images/writing.png"
                            onClicked: stackView.push("GameLoaderPage.qml", {
                                "url": coreSettings.dyxiGetGameList + "?type=" + gameTypeId[0].id,
                                "pageTitle": selectGamePage.gameTypeId[0].type,
                                "avatar": "qrc:/ui/images/phonics.png",
                                "resoucesUrl": selectGamePage.gameTypeId[0].type
                            })
                        }

                        GameItem {
                            labelText: "Word Recog"
                            imageSource: "qrc:/ui/images/writing.png"
                            onClicked: stackView.push("GameLoaderPage.qml", {
                                "url": coreSettings.dyxiGetGameList + "?type=" + gameTypeId[2].id,
                                "pageTitle": selectGamePage.gameTypeId[2].type,
                                "avatar": "qrc:/ui/images/phonics.png",
                                "resoucesUrl": selectGamePage.gameTypeId[2].type
                            })
                        }

                        GameItem {
                            labelText: "Writing Practice"
                            imageSource: "qrc:/ui/images/reading.png"
                        }
                    }
                }
            }
        }

        Component.onCompleted: {
            // console.log(coreSettings.dyxiGameTypeIds);
            networkPresets.getGameTypeIdRequest(coreSettings.dyxiGameTypeIds);
            networkPresets.getGameCategoryIdRequest(coreSettings.dyxiGetGameCategoryList);
        }

        Connections {
            target: networkPresets
            function onGameTypeIdsChanged() {
                if (true) {
                    selectGamePage.gameTypeId = networkPresets.gameTypeIds;
                    console.log(selectGamePage.gameTypeId[0].type);
                }
            }

            // function
        }
    }
}

/**

🧠 Brain Training
📖 Reading Practice
🔤 Letter Learning
🌟 Reading Helper
💙 Learning Support
🧩 Word Builder
🚀 Learning Journey

🤝 Learning Support
💙 Reading Support
🌟 Guided Learning
🧭 Learning Path
🔤 Letter Helper
📖 Reading Companion
🧠 Brain Support
🌈 Learning Adventure
🚀 Learning Journey
⭐ Star Learner
🎉 Fun Learning
🦉 Wise Owl Mode
🌻 Growth Mode
🎨 Creative Learning
✨ Discovery Time

🧠 Memory Training
🎴 Memory Match
⚡ Brain Boost
🔄 Recall Practice
🎯 Concentration Mode
🏅 Skill Builder
🧩 Cognitive Challenge

🌟 Reading Helper
📖 Reading Practice
🔤 Letter Learning
🔡 Word Builder
📝 Reading Skills
🎯 Focus Reading
🧩 Word Puzzle
💡 Learn & Read
🌈 Easy Reading

  **/

import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "../Components"
import General
import Recognition
import Writing

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
            id: scroll
            anchors.fill: parent
            anchors.centerIn: parent

            clip: true

            Flickable {
                contentHeight: grid.height
                // contentWidth: grid.width
                anchors.centerIn: parent
                // The Grid of Distinct Items
                Grid {
                    id: grid
                    width: parent.width
                    spacing: 30
                    // anchors.horizontalCenter: parent.horizontalCenter
                    // flow: Flow.LeftToRight
                    GameItem {
                        labelText: "Phonics Fun"
                        imageSource: "qrc:/ui/images/phonics.png"
                        accentColor: "#FF8A65"
                        onClicked: stackView.push("GameLoaderPage.qml", {
                            // "url": coreSettings.baseUrl+"/api/game-by-type"+"?type=1"+"age"+UserSession.userAge,
                            "url": "https://mvp.dyxi.site/api/game-types" + "?type=1",
                            "pageTitle": selectGamePage.gameTypeId[0].type,
                            "avatar": "qrc:/ui/images/phonics.png",
                            "resoucesUrl": selectGamePage.gameTypeId[4].type
                        })
                    }

                    GameItem {
                        labelText: "Word Tracing"
                        imageSource: "qrc:/ui/images/tracing.png"
                        accentColor: "#4DB6AC"
                        // onClicked: stackView.push("ABC123.qml")
                        onClicked: stackView.push("qrc:/Writing/Writing/WritingMainPlayGround.qml")
                    }

                    GameItem {
                        labelText: "Recognition"
                        imageSource: "qrc:/ui/images/recognition.png"
                        accentColor: "#9575CD"
                        onClicked: stackView.push("GameLoaderPage.qml", {
                            "url": "https://mvp.dyxi.site/api/game-types" + "?type=" + selectGamePage.gameTypeId[3].id,
                            "pageTitle": selectGamePage.gameTypeId[3].type,
                            "avatar": "qrc:/ui/images/recognition.png",
                            "resoucesUrl": selectGamePage.gameTypeId[3].type,
                            "typeId": selectGamePage.gameTypeId[3].id
                        })
                    }

                    GameItem {
                        labelText: "Reading Time"
                        imageSource: "qrc:/ui/images/reading.png"
                        accentColor: "#F06292"
                        onClicked: stackView.push("qrc:/modules/modules/Recognition_Shape_Explorer_Level1.qml")
                    }

                    GameItem {
                        labelText: "Writing Practice"
                        imageSource: "qrc:/ui/images/writing.png"
                        accentColor: "#FFD54F"
                        onClicked: stackView.push("qrc:/modules/dyscalculia/mathdice/Dyscalculia/MathDice/MathDiceMain.qml")
                    }

                    GameItem {
                        labelText: "Writing Practice"
                        imageSource: "qrc:/ui/images/writing.png"
                        accentColor: "#FFD54F"
                        onClicked: stackView.push("qrc:/modules/dyscalculia/clumsythief/Dyscalculia/ClumsyThief/ClumsyMain.qml")
                    }

                    GameItem {
                        labelText: "Writing Practice"
                        imageSource: "qrc:/ui/images/writing.png"
                        accentColor: "#FFD54F"
                        onClicked: stackView.push("qrc:/modules/dyscalculia/tenframegame/Dyscalculia/TenFrames/TenFramesMain.qml")
                    }

                    GameItem {
                        labelText: "Writing Practice"
                        imageSource: "qrc:/ui/images/writing.png"
                        accentColor: "#FFD54F"
                        onClicked: stackView.push("qrc:/modules/dyscalculia/numicon1/Dyscalculia/Numicon1/NumiconMain.qml")
                    }

                    GameItem {
                        labelText: "Writing Practice"
                        imageSource: "qrc:/ui/images/reading.png"
                        accentColor: "#FFD54F"
                        onClicked: stackView.push("qrc:/modules/phonetics/wordrecog/Phonetics/WordRecognitionGame/WordRecognitionMain.qml")
                    }

                    GameItem {
                        labelText: "Writing Practice"
                        imageSource: "qrc:/ui/images/reading.png"
                        accentColor: "#FFD54F"
                        onClicked: stackView.push("qrc:/ui/UIModule/Pages/NewGamepPage.qml")
                    }
                }

                // GridView{
                //     id: gridView
                //     anchors.fill: parent
                //     model: gridModel
                // }
            }
        }

        Component.onCompleted: {
            console.log(coreSettings.dyxiGameTypeIds);
            networkPresets.getGameTypeIdRequest(coreSettings.dyxiGameTypeIds);
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

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Recognition"

Page {
    id: root
    width: 1024
    height: 768
    visible: true
    title: "ABC & 123 Fun - Dyslexia Friendly Game"

    FontLoader {
        id: dyslexiaFont
        source: "qrc:/img/Recognition/assets/OpenDyslexic-Regular.otf"
    }

    Rectangle {
        id: mainBackground
        anchors.fill: parent

        Image {
            source: "qrc:/img/Recognition/assets/images/background_main.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }

        StackView {
            id: stackView
            anchors.fill: parent
            initialItem: homeScreen
        }
    }

    Component {
        id: homeScreen
        Item {
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 40

                Text {
                    text: "ABC & 123 Fun"
                    font.family: dyslexiaFont.name
                    font.pixelSize: 80
                    color: "#4A4A4A"
                    Layout.alignment: Qt.AlignHCenter
                    style: Text.Outline
                    styleColor: "white"
                }

                Image {
                    source: "qrc:/img/Recognition/assets/images/character_guide.png"
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 300
                    Layout.alignment: Qt.AlignHCenter
                    fillMode: Image.PreserveAspectFit
                }

                Button {
                    id: playButton
                    Layout.alignment: Qt.AlignHCenter
                    background: Image {
                        source: "qrc:/img/Recognition/assets/images/button_play.png"
                        width: 150
                        height: 150
                    }
                    onClicked: {
                        stackView.push(levelSelectScreen)
                    }
                }
            }
        }
    }

    Component {
        id: levelSelectScreen
        Item {
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 30

                Text {
                    text: "Choose a Level"
                    font.family: dyslexiaFont.name
                    font.pixelSize: 50
                    color: "#4A4A4A"
                    Layout.alignment: Qt.AlignHCenter
                }

                RowLayout {
                    spacing: 20
                    LevelButton { level: 1; title: "Letters"; color: "#FFD700"; onClicked: stackView.push(gameLevel1) }
                    LevelButton { level: 2; title: "Matching"; color: "#87CEEB"; onClicked: stackView.push(gameLevel2) }

                }

                Button {
                    text: "Back"
                    onClicked: stackView.pop()
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    // Helper component for Level Buttons
    Component {
        id: levelButtonComp
        Button {
            property int level: 1
            property string title: ""
            property color color: "white"

            contentItem: Text {
                text: level + "\n" + title
                font.family: dyslexiaFont.name
                font.pixelSize: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#4A4A4A"
            }

            background: Rectangle {
                implicitWidth: 180
                implicitHeight: 180
                radius: 20
                color: parent.down ? Qt.darker(parent.color, 1.2) : parent.color
                border.width: 5
                border.color: "white"
            }
        }
    }

    // Level components
    Component { id: gameLevel1; GameLevel1 {} }
    Component { id: gameLevel2; GameLevel2 {} }

}

import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia 6.4
import "ShapeExplorer"
import "ShapeExplorer/Telemetry.js" as Telemetry
import Dataset
import General

Page{
 id: shape_level1

 property int typeId: 0

  RecognitionShapeExplorerDataset{
      id: recogDataset
  }
  CoreSettings {
      id: coreSettings
  }


 Rectangle {
        anchors.fill: parent
        Image {
            source: "qrc:/Recognition/ShapeExplorer/assets/background.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }
    }

    // Audio
    SoundEffect { id: soundSuccess; source: "qrc:/Recognition/ShapeExplorer/assets/success.wav" }
    SoundEffect { id: soundFailure; source: "qrc:/Recognition/ShapeExplorer/assets/failure.wav" }
    SoundEffect { id: soundRabbit; source: "qrc:/Recognition/ShapeExplorer/assets/rabbit_appear.wav" }

    Rabbit {
        id: rabbit
        z: 100
    }

    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: {
            rabbit.show()
            soundRabbit.play()
        }
    }

    // Game Board
    Row {
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 50

        TargetSlot { id: slotCircle; shapeType: "circle"; imageSource: "qrc:/Recognition/ShapeExplorer/assets/circle.png" }
        TargetSlot { id: slotSquare; shapeType: "square"; imageSource: "qrc:/Recognition/ShapeExplorer/assets/square.png" }
        TargetSlot { id: slotTriangle; shapeType: "triangle"; imageSource: "qrc:/Recognition/ShapeExplorer/assets/triangle.png" }
        TargetSlot { id: slotStar; shapeType: "star"; imageSource: "qrc:/Recognition/ShapeExplorer/assets/star.png" }
    }

    // Draggable Shapes
    Shape {
        id: shapeCircle
        x: 100; y: 500; shapeType: "circle"; imageSource: "qrc:/Recognition/ShapeExplorer/assets/circle.png"
        onDragStarted: Telemetry.recordSelection()
        onDragEnded: checkMatch(shapeCircle, slotCircle)
    }
    Shape {
        id: shapeSquare
        x: 300; y: 500; shapeType: "square"; imageSource: "qrc:/Recognition/ShapeExplorer/assets/square.png"
        onDragStarted: Telemetry.recordSelection()
        onDragEnded: checkMatch(shapeSquare, slotSquare)
    }
    Shape {
        id: shapeTriangle
        x: 500; y: 500; shapeType: "triangle"; imageSource: "qrc:/Recognition/ShapeExplorer/assets/triangle.png"
        onDragStarted: Telemetry.recordSelection()
        onDragEnded: checkMatch(shapeTriangle, slotTriangle)
    }
    Shape {
        id: shapeStar
        x: 700; y: 500; shapeType: "star"; imageSource: "qrc:/Recognition/ShapeExplorer/assets/star.png"
        onDragStarted: Telemetry.recordSelection()
        onDragEnded: checkMatch(shapeStar, slotStar)
    }

    function checkMatch(shape, slot) {
        var distance = Math.sqrt(Math.pow(shape.x + shape.width/2 - (slot.x + slot.width/2 + slot.parent.x), 2) +
                                 Math.pow(shape.y + shape.height/2 - (slot.y + slot.height/2 + slot.parent.y), 2))

        if (distance < 80) {
            shape.isMatched = true
            soundSuccess.play()
            Telemetry.recordMatch(shape.shapeType, true, 2000) // Simplified duration for demo
        } else {
            // Return to start
            shape.x = shape.startPos.x
            shape.y = shape.startPos.y
            soundFailure.play()
            Telemetry.recordMatch(shape.shapeType, false, 1000)
        }
    }

    // Global Input Tracking for Metrics
    property var lastPressTime: 0
    property var lastPressPos: Qt.point(0,0)

    MouseArea {
        // id:
        anchors.fill: parent
        propagateComposedEvents: true
         preventStealing: true
        onPressed: (mouse) => {
            // id: mouse
            lastPressTime = Date.now()
            lastPressPos = Qt.point(mouse.x, mouse.y)
            mouse.accepted = false // change to true in other to trigger onRelease


        }
        onReleased: (mouse)=>{
            var duration = Date.now() - lastPressTime
            var dx = mouse.x - lastPressPos.x
            var dy = mouse.y - lastPressPos.y
            var direction = Math.abs(dx) > Math.abs(dy) ? (dx > 0 ? "right" : "left") : (dy > 0 ? "down" : "up")
            // console.log("start realease")
            // console.log(duration)
            // console.log(dx)

            var rabbitVisDur = rabbit.visible ? (Date.now() - rabbit.visibilityStartTime) : 0
            Telemetry.recordInput(lastPressTime, duration, direction, rabbit.visible, rabbitVisDur)
            mouse.accepted = false
        }
    }

    QuitButton {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        onClicked: {
            var result = Telemetry.getFinalJson()
            // recogDataset.totalGameTime = Telemetry.gameData.total_game_time
            // recogDataset.startTime = Telemetry.gameData.start_time
            // recogDataset.totalCorrect = Telemetry.gameData.total_correct
            // recogDataset.totalFailed = Telemetry.gameData.total_failed
            // recogDataset.totalTries = Telemetry.gameData.total_tries
            // recogDataset.creativeIndex = Telemetry.gameData.creative_index
            // recogDataset.problemSolvingIndex = Telemetry.gameData.problem_solving_index
            // console.log(UserSession.userId);

            // Set Custom Data Here, like userId , Programe uuid or Id, Type, Category
            recogDataset.userId = UserSession.userId
            recogDataset.gameType = shape_level1.typeId
            recogDataset.userAge = UserSession.userAge


            console.log(UserSession.userId)

            // recogDataset.gatherData(coreSettings.dyxiRecognitionPostShapeExplorer, result);
            console.log("GAME_METRICS_START")
            console.log(result)
            console.log("GAME_METRICS_END")
            // In a real app, you might save this to a file
            stackView.pop()
        }
    }

    Component.onCompleted: Telemetry.startGame()

}



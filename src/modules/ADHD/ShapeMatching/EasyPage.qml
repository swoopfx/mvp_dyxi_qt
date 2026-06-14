import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: easyPageRoot
    anchors.fill: parent

    // In 'easy' difficulty (Ages 4-6), we render 3 simple shapes with a generous snapping range
    property double snapTolerance: 110.0

    Row {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 40

        // Left Drag sources
        Column {
            width: parent.width * 0.48
            height: parent.height
            spacing: 50
            anchors.verticalCenter: parent.verticalCenter

            ShapeItem {
                id: cubeShape
                shapeType: "cube"
                shapeName: "Magic Cube"
                shapeGlyph: "🧊"
                baseColor: "#EC4899"
                gradientTo: "#BE185D"
                targetX: socketCube.x + socketColumn.x
                targetY: socketCube.y + socketColumn.y
                tolerance: easyPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 100.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }

            ShapeItem {
                id: sphereShape
                shapeType: "sphere"
                shapeName: "Sun Sphere"
                shapeGlyph: "🟡"
                baseColor: "#EAB308"
                gradientTo: "#CA8A04"
                targetX: socketSphere.x + socketColumn.x
                targetY: socketSphere.y + socketColumn.y
                tolerance: easyPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 100.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }

            ShapeItem {
                id: pyramidShape
                shapeType: "pyramid"
                shapeName: "Retro Pyramid"
                shapeGlyph: "🔺"
                baseColor: "#3B82F6"
                gradientTo: "#1D4ED8"
                targetX: socketPyramid.x + socketColumn.x
                targetY: socketPyramid.y + socketColumn.y
                tolerance: easyPageRoot.snapTolerance
                onMatched: backend.logMatch(shapeName, shapeType, true, duration, 100.0)
                onFailed: backend.logMatch(shapeName, shapeType, false, duration, 0.0)
            }
        }

        // Right Sockets
        Column {
            id: socketColumn
            width: parent.width * 0.48
            height: parent.height
            spacing: 50
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                id: socketCube
                width: 140; height: 100; radius: 15
                color: "#10EC4899"
                border.color: "#EC4899"
                border.width: 1.5
                opacity: cubeShape.isMatched ? 1.0 : 0.4

                Text {
                    anchors.centerIn: parent
                    text: cubeShape.isMatched ? "🎉 MATCHED" : "Place Cube"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#EC4899"
                }
            }

            Rectangle {
                id: socketSphere
                width: 140; height: 100; radius: 15
                color: "#10EAB308"
                border.color: "#EAB308"
                border.width: 1.5
                opacity: sphereShape.isMatched ? 1.0 : 0.4

                Text {
                    anchors.centerIn: parent
                    text: sphereShape.isMatched ? "🎉 MATCHED" : "Place Sphere"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#CA8A04"
                }
            }

            Rectangle {
                id: socketPyramid
                width: 140; height: 100; radius: 15
                color: "#103B82F6"
                border.color: "#3B82F6"
                border.width: 1.5
                opacity: pyramidShape.isMatched ? 1.0 : 0.4

                Text {
                    anchors.centerIn: parent
                    text: pyramidShape.isMatched ? "🎉 MATCHED" : "Place Pyramid"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#3B82F6"
                }
            }
        }
    }
}

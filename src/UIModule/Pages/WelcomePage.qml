import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
// import Qt5Compat.GraphicalEffects
// import UIModule


Page{
    Rectangle {
        id: root
        anchors.fill: parent
        color: "#0a0a0a" // Dark professional background



        // --- Background Glow ---
        // RadialGradient {
        //     anchors.fill: parent
        //     // gradient: Gradient {
        //     //     GradientStop {
        //     //         position: 0.0
        //     //         color: "#1a1a2e"
        //     //     }
        //     //     GradientStop {
        //     //         position: 1.0
        //     //         color: "#0a0a0a"
        //     //     }
        //     // }
        // }

        // --- Laser Vector Strip Animation ---
        Canvas {
            id: laserCanvas
            anchors.fill: parent
            property real progress: 0.0

            onProgressChanged: requestPaint()

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                if (progress <= 0)
                    return;

                // Draw laser line
                ctx.lineWidth = 3;
                ctx.lineCap = "round";

                // Create a glowing gradient for the laser
                var grad = ctx.createLinearGradient(0, height * 0.7, width, height * 0.7);
                grad.addColorStop(0, "transparent");
                grad.addColorStop(0.5, "#00f2ff"); // Cyan laser
                grad.addColorStop(1, "transparent");

                ctx.strokeStyle = grad;
                ctx.shadowBlur = 15;
                ctx.shadowColor = "#00f2ff";

                ctx.beginPath();
                ctx.moveTo(0, height * 0.7);
                ctx.lineTo(width * progress, height * 0.7);
                ctx.stroke();
            }

            SequentialAnimation on progress {
                id: laserAnim
                running: false
                NumberAnimation {
                    from: 0
                    to: 1
                    duration: 800
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // --- Bouncing Logo ---
        Image {
            id: logo
            source: "qrc:/ui/images/logo.png"
            width: 200
            height: 200
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            y: -height // Start off-screen
            opacity: 0

            SequentialAnimation {
                id: bounceAnim
                running: true

                // Initial drop and bounce
                ParallelAnimation {
                    NumberAnimation {
                        target: logo
                        property: "y"
                        from: -200
                        to: root.height * 0.3
                        duration: 1200
                        easing.type: Easing.OutBounce
                    }
                    NumberAnimation {
                        target: logo
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 500
                    }
                }

                // Subtle hover effect after bounce
                SequentialAnimation {
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: logo
                        property: "y"
                        to: root.height * 0.3 - 10
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: logo
                        property: "y"
                        to: root.height * 0.3
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            // Trigger laser when logo hits bottom of first bounce
            onYChanged: {
                if (y >= root.height * 0.3 && !laserAnim.running && laserCanvas.progress === 0) {
                    laserAnim.start();
                }
            }
        }

        // --- Welcome Button ---
        Button {
            id: welcomeButton
            text: "Start Learning"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 80
            anchors.horizontalCenter: parent.horizontalCenter
            width: 200
            height: 50
            opacity: 0
            scale: 0.8

            contentItem: Text {
                text: welcomeButton.text
                font.pixelSize: 18
                font.bold: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                id: btnBg
                implicitWidth: 200
                implicitHeight: 50
                color: welcomeButton.down ? "#00c2cc" : "#00f2ff"
                radius: 25

                layer.enabled: true
                // layer.effect: DropShadow {
                //     transparentBorder: true
                //     color: "#4000f2ff"
                //     radius: 10
                //     samples: 17
                // }
            }

            SequentialAnimation {
                id: buttonInAnim
                running: false
                PauseAnimation {
                    duration: 1500
                } // Wait for logo and laser
                ParallelAnimation {
                    NumberAnimation {
                        target: welcomeButton
                        property: "opacity"
                        to: 1
                        duration: 600
                    }
                    NumberAnimation {
                        target: welcomeButton
                        property: "scale"
                        to: 1
                        duration: 600
                        easing.type: Easing.OutBack
                    }
                }
            }

            onClicked: {
                // console.log("Welcome clicked!");
                stackView.push("LoginPage.qml")
            }
        }

        // Start button animation when page loads
        Component.onCompleted: {
            buttonInAnim.start();
        }
    }
}
import QtQuick 2.0
import "circledeploy.js" as CircleController

Item {
    property int xPos: 5
    property int yPos: 5
    property int angle: 0
    property string rotDir: ""
    property int spaceDistance: 97
    property int interiorSpaceWidth: 90
    property string imageSource: ""

    function updatePosition(newX, newY) {
        xPos = newX
        yPos = newY
        state = "nonhighlighted"
        CircleController.retract()
    }

    id: piece
    width: interiorSpaceWidth
    height: width
    anchors.left: board.left
    anchors.top: board.top
    anchors.leftMargin: 73 + xPos*spaceDistance
    anchors.topMargin: 73 + yPos*spaceDistance
    Image {
        id: pieceImage
        anchors.fill: parent
        source: imageSource
        fillMode: Image.PreserveAspectFit
        rotation: angle
        Behavior on rotation {
            RotationAnimation {
                duration: 500
                direction: rotDir === "CW" ? RotationAnimation.Clockwise : RotationAnimation.Counterclockwise
            }
        }
    }
    Rectangle {
        id: highlightRect
        anchors.fill: parent
        anchors.margins: 10
        radius: 20
        color: "green"
        opacity: 0
        z: 1
    }
    Image {
        id: cwArrow
        source: "res/cwarrow.png"
        fillMode: Image.PreserveAspectFit
        width: 60
        anchors.top: parent.bottom
        anchors.right: parent.left
        anchors.margins: -30
        opacity: 0
        z: 1
        MouseArea {
            anchors.fill: parent
            onClicked: {
                rotDir = "CW"
                angle += 90
                piece.state = "nonhighlighted";
                CircleController.retract()
            }
        }
    }
    Image {
        id: ccwArrow
        source: "res/ccwarrow.png"
        fillMode: Image.PreserveAspectFit
        width: 60
        anchors.bottom: parent.top
        anchors.left: parent.right
        anchors.margins: -30
        opacity: 0
        z: 1
        MouseArea {
            anchors.fill: parent
            onClicked: {
                rotDir = "CCW"
                angle -= 90
                piece.state = "nonhighlighted";
                CircleController.retract()
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (parent.state == "highlighted")
            {
                parent.state = "nonhighlighted";
                CircleController.retract()
            }
            else {
                parent.state = "highlighted";
                var positions = 255;
                CircleController.deploy(positions)
            }
        }
    }
    states: [
        State {
            name: "highlighted"
            PropertyChanges {
                target: highlightRect
                opacity: 0.4
            }
            PropertyChanges {
                target: cwArrow
                opacity: 1
            }
            PropertyChanges {
                target: ccwArrow
                opacity: 1
            }
        },
        State {
            name: "nonhighlighted"
            PropertyChanges {
                target: highlightRect
                opacity: 0
            }
            PropertyChanges {
                target: cwArrow
                opacity: 0
            }
            PropertyChanges {
                target: ccwArrow
                opacity: 0
            }
        }
    ]
    transitions: Transition {
        PropertyAnimation {
            duration: 300
            properties: "opacity"
            targets: [cwArrow, ccwArrow, highlightRect]
        }
    }

//    transform: Rotation {

//    }

    Component.onCompleted: {
        CircleController.init(piece)
    }
}

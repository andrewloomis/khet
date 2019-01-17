import QtQuick 2.0
import "circledeploy.js" as CircleController
import "coordcalculator.js" as CoordCalculator
import khet.gamemanager 1.0

Item {
    property GameManager gameManager
    property Board board
    property int index
    property int xPos: 5
    property int yPos: 5
    property int angle
    property string rotDir: "CW"
    property int interiorSpaceWidth: 90
    property string imageSource: ""

    function updatePosition(newX, newY) {
        // Is Swap?
        var swappedPieceIndex = gameManager.isPieceAtPosition(newX, newY)
        if (swappedPieceIndex >= 0)
        {
            gameManager.updatePiecePosition(swappedPieceIndex, xPos, yPos);
            var swappedPiece = board.getPiece(swappedPieceIndex)
            swappedPiece.xPos = xPos
            swappedPiece.yPos = yPos
        }

        xPos = newX
        yPos = newY
        console.log("piece ", index, " moved to ", xPos, ",", yPos)
        gameManager.updatePiecePosition(index, xPos, yPos);
        state = "nonhighlighted"
    }

    id: piece
    width: interiorSpaceWidth
    height: width
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: CoordCalculator.pieceLeftAnchor(xPos)
    anchors.topMargin: CoordCalculator.pieceTopAnchor(yPos)
    Image {
        id: pieceImage
        anchors.fill: piece
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
        anchors.fill: piece
        anchors.margins: 10
        radius: 20
        color: "green"
        opacity: 0
        z: 1
    }
    Image {
        id: cwArrow
        property bool clickEnabled: false
        source: "res/cwarrow.png"
        fillMode: Image.PreserveAspectFit
        width: 60
        anchors.top: piece.bottom
        anchors.right: piece.left
        anchors.margins: -30
        opacity: 0
        z: 1
        MouseArea {
            anchors.fill: parent
            enabled: parent.clickEnabled
            onClicked: {
                rotDir = "CW"
                angle = (angle % 360) + 90
                gameManager.updatePieceAngle(index, angle)
                console.log("piece", index, "rotating CW to", angle, "degrees")
                piece.state = "nonhighlighted";
            }
        }
    }
    Image {
        id: ccwArrow
        property bool clickEnabled: false
        source: "res/ccwarrow.png"
        fillMode: Image.PreserveAspectFit
        width: 60
        anchors.bottom: piece.top
        anchors.left: piece.right
        anchors.margins: -30
        opacity: 0
        z: 1
        MouseArea {
            anchors.fill: parent
            enabled: parent.clickEnabled
            onClicked: {
                rotDir = "CCW"
                angle = (angle == 0 || angle == 360) ? 270 : (angle % 360) - 90
                gameManager.updatePieceAngle(index, angle)
                console.log("piece", index, "rotating CCW to", angle, "degrees")
                piece.state = "nonhighlighted";
            }
        }
    }
    MouseArea {
        anchors.fill: piece
        onClicked: {
            if (piece.state == "highlighted")
            {
                piece.state = "nonhighlighted";
                CircleController.retract()
            }
            else {
                forceActiveFocus()
                piece.state = "highlighted";
            }
        }
        onActiveFocusChanged: {
            if (!activeFocus && piece.state === "highlighted") {
                piece.state = "nonhighlighted";
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
                clickEnabled: true
            }
            PropertyChanges {
                target: ccwArrow
                opacity: 1
                clickEnabled: true
            }
            StateChangeScript {
                script: {
                    var positions = gameManager.possibleTranslationsForPiece(index);
                    CircleController.deploy(positions)
                }
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
                clickEnabled: false
            }
            PropertyChanges {
                target: ccwArrow
                opacity: 0
                clickEnabled: false
            }
            StateChangeScript {
                script: {
                    CircleController.retract()
                }
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

//    Connections {
//        id: gameManager

//    }

    Component.onCompleted: {
        CircleController.init(piece)
    }
}

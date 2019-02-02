import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Window 2.12
import "gameloader.js" as GameLoader
import "beammapper.js" as BeamMapper
import khet.gamemanager 1.0

Image {
    id: root
    focus: true
    fillMode: Image.PreserveAspectFit
    source: "res/board.png"
    sourceSize.width: 555
    sourceSize.height: 457
    z: -1

    property GameManager gameManager

    function getPiece(index)
    {
        return GameLoader.getPiece(index)
    }
    function killPiece(index)
    {
        GameLoader.killPiece(index)
    }
    function unstackPiece(index, color)
    {
        GameLoader.unstackPiece(index, color)
    }
    function reset()
    {
        GameLoader.loadGame(gameManager.getPiecePositions())
    }

    Timer {
        id: beamDestroyTimer
        interval: 1000
        onTriggered: {
            BeamMapper.destroyBeam()
        }
    }

    function createOpponentBeam()
    {
        if (gameManager.myColor === "red")
        {
            BeamMapper.createBeam(gameManager.getBeamCoords(9,7), 9, 7)
        }
        else
        {
            BeamMapper.createBeam(gameManager.getBeamCoords(0,0), 0, 0)
        }

        beamDestroyTimer.start()
    }

    Button {
        id: greyPlayerButton
        enabled: gameManager.myColor == "grey"
        width: 35/2
        height: width
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 85/2
        anchors.bottomMargin: 10/2

        property bool beamCreated: false
        background: Rectangle {
            id: greyPlayerButton_rect
            anchors.fill: parent
            radius: width/2
            color: "red"
        }
        onPressed: {
            if (gameManager.mode == "sandbox" ||
                    (gameManager.isPlayerTurn() && gameManager.isMoveComplete()))
            {
                greyPlayerButton_rect.color = "#4F0000"
                BeamMapper.createBeam(gameManager.getBeamCoords(9,7), 9, 7)
                beamCreated = true
                gameManager.turnFinished()
                gameManager.stopHighlightAnimation()
            }
        }
        onHoveredChanged: {
            if(beamCreated) {
                BeamMapper.destroyBeam()
                greyPlayerButton_rect.color = "red"
                beamCreated = false
            }
        }

        onReleased: {
            if(beamCreated) {
                BeamMapper.destroyBeam()
                greyPlayerButton_rect.color = "red"
                beamCreated = false
            }
        }
    }

    Button {
        id: redPlayerButton
        enabled: gameManager.myColor == "red"
        width: 35/2
        height: width
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 85/2
        anchors.topMargin: 10/2
        property bool beamCreated: false
        background: Rectangle {
            id: redPlayerButton_rect
            anchors.fill: parent
            radius: width/2
            color: "red"
        }
        onPressed: {
            if (gameManager.mode == "sandbox" ||
                    (gameManager.isPlayerTurn() && gameManager.isMoveComplete()))
            {
                redPlayerButton_rect.color = "#4F0000"
                BeamMapper.createBeam(gameManager.getBeamCoords(0,0), 0, 0)
                beamCreated = true
                gameManager.turnFinished()
                gameManager.stopHighlightAnimation()
            }
        }
        onHoveredChanged: {
            if(beamCreated) {
                BeamMapper.destroyBeam()
                redPlayerButton_rect.color = "red"
                beamCreated = false
            }
        }

        onReleased: {
            if(beamCreated) {
                BeamMapper.destroyBeam()
                redPlayerButton_rect.color = "red"
                beamCreated = false
            }
        }
    }

    Component.onCompleted: {
        BeamMapper.init(root)
        GameLoader.init(root, gameManager)
        GameLoader.loadGame(gameManager.getPiecePositions())
    }
}

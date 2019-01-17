import QtQuick 2.0
import QtQuick.Controls 2.4
import "gameloader.js" as GameLoader
import "beammapper.js" as BeamMapper
import khet.gamemanager 1.0

Image {
    id: root
    fillMode: Image.PreserveAspectFit
    source: "res/board.png"
    anchors.centerIn: parent
    z: -1

    function getPiece(index)
    {
        return GameLoader.getPiece(index)
    }

    Button {
        id: button
        width: 35
        height: width
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 85
        anchors.bottomMargin: 10
        background: Rectangle {
            id: rect
            anchors.fill: parent
            radius: width/2
            color: "red"

        }
        onPressed: {
            BeamMapper.createBeam(gameManager.getBeamCoords())
            rect.color = "#4F0000"
        }
        onReleased: {
            BeamMapper.destroyBeam()
            rect.color = "red"
        }

//        states: State {
//            when: button.pressed
//            PropertyChanges {
//                target: rect
//                color: "#4F0000"
//            }
//        }
    }
    GameManager {
        id: gameManager
    }
    Component.onCompleted: {
        BeamMapper.init(root)
        GameLoader.init(root, gameManager)
        GameLoader.loadGame(gameManager.getPiecePositions())
    }
}

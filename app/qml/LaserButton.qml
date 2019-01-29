import QtQuick 2.0
import QtQuick.Controls 2.4
import "beammapper.js" as BeamMapper
import khet.gamemanager 1.0

Button {
    id: button

    property GameManager gameManager
    property string playerColor

    width: 35
    height: width
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.rightMargin: 85
    anchors.bottomMargin: 10
    property bool beamCreated: false
    background: Rectangle {
        id: rect
        anchors.fill: parent
        radius: width/2
        color: "red"
    }
    onPressed: {
        if (gameManager.isGodMode() || gameManager.isPlayerTurn())
        {
            BeamMapper.createBeam(gameManager.getBeamCoords())
            beamCreated = true
        }
        rect.color = "#4F0000"
    }
    onHoveredChanged: {
        if(beamCreated) {
            BeamMapper.destroyBeam()
            rect.color = "red"
            beamCreated = false
        }
    }

    onReleased: {
        if(beamCreated) {
            BeamMapper.destroyBeam()
            rect.color = "red"
            beamCreated = false
        }
    }
}

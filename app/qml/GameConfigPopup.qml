import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Popup {
    id: root
    dim: true
    height: 200 * root.scaleRatio
    width: 700 * root.scaleRatio
    property real scaleRatio
    property string mode: "sandbox"

    function setMode(mode) {
        if (mode === "sandbox" ||
                mode === "multiplayer")
        {
            root.mode = mode
        }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        anchors.margins: 20 * root.scaleRatio
        spacing: 20 * root.scaleRatio
        RoundButton {
            text: "Classic"
            font.pixelSize: 50 * root.scaleRatio
            radius: 20 * root.scaleRatio
            onHoveredChanged: {
                if (hovered) {
                    highlighted = true
                }
                else {
                    highlighted = false
                }
            }
            onPressed: {
                if (mode === "multiplayer")
                {
                    matchMakerPopup.setConfiguration("classic")
                    matchMakerPopup.open()
                }
                else
                {
                    game.setConfiguration("classic")
                    stack.push(game)
                }
                root.close()
            }
        }
        RoundButton {
            text: "Imhotep"
            font.pixelSize: 50 * root.scaleRatio
            radius: 20 * root.scaleRatio
            onHoveredChanged: {
                if (hovered) {
                    highlighted = true
                }
                else {
                    highlighted = false
                }
            }
            onPressed: {
                if (mode === "multiplayer")
                {
                    matchMakerPopup.setConfiguration("imhotep")
                    matchMakerPopup.open()
                }
                else
                {
                    game.setConfiguration("imhotep")
                    stack.push(game)
                }
                root.close()
            }
        }
        RoundButton {
            text: "Dynasty"
            font.pixelSize: 50 * root.scaleRatio
            radius: 20 * root.scaleRatio
            onHoveredChanged: {
                if (hovered) {
                    highlighted = true
                }
                else {
                    highlighted = false
                }
            }
            onPressed: {
                if (mode === "multiplayer")
                {
                    matchMakerPopup.setConfiguration("dynasty")
                    matchMakerPopup.open()
                }
                else
                {
                    game.setConfiguration("dynasty")
                    stack.push(game)
                }
                root.close()
            }
        }
    }
    background: Rectangle {
        anchors.fill: parent
        color: "grey"
        opacity: 0.9
        radius: 40 * root.scaleRatio
        z: -1
    }
}


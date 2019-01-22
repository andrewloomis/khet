import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Popup {
    id: root
    dim: true
    height: row.childrenRect.height + 70
    width: row.childrenRect.width + 70
    RowLayout {
        id: row
        anchors.centerIn: parent
        anchors.margins: 20
        spacing: 20
        RoundButton {
            icon.source: "res/globe.png"
            icon.width: 300
            icon.height: 300
            text: "Multiplayer"
            font.pixelSize: 40
            display: Button.TextUnderIcon
            radius: 20
            onHoveredChanged: {
                if (hovered) {
                    icon.color = "red"
                }
                else {
                    icon.color = "black"
                }
            }
            onPressed: {
                matchMakerPopup.open()
                root.close()
            }
        }
        RoundButton {
            icon.source: "res/sandbox.png"
            icon.width: 300
            icon.height: 300
            text: "Sandbox"
            font.pixelSize: 40
            display: Button.TextUnderIcon
            radius: 20
            onHoveredChanged: {
                if (hovered) {
                    icon.color = "blue"
                }
                else {
                    icon.color = "black"
                }
            }
            onPressed: {
                stack.push(game)
                root.close()
            }
        }
    }
    background: Rectangle {
        anchors.fill: parent
        color: "grey"
        opacity: 0.9
        radius: 40
        z: -1
    }
}

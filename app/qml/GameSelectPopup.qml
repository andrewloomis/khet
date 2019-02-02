import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Popup {
    id: root
    dim: true
    height: row.childrenRect.height + 70 * root.scaleRatio
    width: row.childrenRect.width + 70 * root.scaleRatio
    property real scaleRatio

    RowLayout {
        id: row
        anchors.centerIn: parent
        anchors.margins: 20 * root.scaleRatio
        spacing: 20 * root.scaleRatio
        RoundButton {
            icon.source: "res/globe.png"
            icon.width: 300 * root.scaleRatio
            icon.height: 300 * root.scaleRatio
            text: "Multiplayer"
            font.pixelSize: 40 * root.scaleRatio
            display: Button.TextUnderIcon
            radius: 20 * root.scaleRatio
            onHoveredChanged: {
                if (hovered) {
                    icon.color = "red"
                }
                else {
                    icon.color = "black"
                }
            }
            onPressed: {
                if (mainMenu.isLoggedIn())
                {
                    matchMakerPopup.open()
                    root.close()
                }
            }
        }
        RoundButton {
            icon.source: "res/sandbox.png"
            icon.width: 300 * root.scaleRatio
            icon.height: 300 * root.scaleRatio
            text: "Sandbox"
            font.pixelSize: 40 * root.scaleRatio
            display: Button.TextUnderIcon
            radius: 20 * root.scaleRatio
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
        radius: 40 * root.scaleRatio
        z: -1
    }
}

import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import khet.matchmaker 1.0

Popup {
    id: root
    property real scaleRatio
    property int rows: 0

    dim: true
    height: (300 + 50 * rows) * root.scaleRatio
    width: 800 * root.scaleRatio

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: 30 * root.scaleRatio
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 20 * root.scaleRatio
            color: "#605060"
            Text {
                anchors.centerIn: parent
                fontSizeMode: Text.FixedSize
                text: "Finding players online..."
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                font.pixelSize: 50 * root.scaleRatio
            }
        }
    }
    onOpened: {
        matchMaker.findOnlinePlayers()
        checkPlayersTimer.start()
    }
    onClosed: {
        checkPlayersTimer.stop()
    }

    Timer {
        id: checkPlayersTimer
        interval: 1000
        onTriggered: {
            matchMaker.findOnlinePlayers()
        }
        repeat: true
    }

    background: Rectangle {
        anchors.fill: parent
        color: "grey"
        opacity: 0.9
        radius: 20 * root.scaleRatio
    }

    Popup {
        id: invitePopup
        property string opponent
        parent: root.parent
        dim: true
        width: parent.width/2
        height: parent.height/7
        transformOrigin: Qt.TopLeftCorner
        topMargin: 20 * root.scaleRatio
        padding: 0

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
            PropertyAnimation { target: invitePopup; properties: "x"; from: -100; to: 20 * root.scaleRatio }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
            PropertyAnimation { target: invitePopup; properties: "x"; from: 20 * root.scaleRatio; to: -100 }
        }

        contentItem:  ColumnLayout {
            id: invitePopup_column
            anchors.margins: 30 * root.scaleRatio
            spacing: 30 * root.scaleRatio
            clip: true

            Text {
                text: "New game invite from " + invitePopup.opponent + "?"
                font.pixelSize: 50 * root.scaleRatio
                color: "white"
                width: parent.width
                height: 100 * root.scaleRatio
                horizontalAlignment: Text.AlignHCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                RoundButton {
                    text: "Accept"
                    font.pixelSize: 50 * root.scaleRatio
                    padding: 7 * root.scaleRatio
                    Layout.fillWidth: true
                    onPressed: {
                        matchMaker.sendInviteAccepted(invitePopup.opponent)
                        stack.push(game)
                        invitePopup.close()
                        root.close()
                    }
                }
                RoundButton {
                    text: "Decline"
                    font.pixelSize: 50 * root.scaleRatio
                    padding: 10 * root.scaleRatio
                    Layout.fillWidth: true
                    onPressed: {
                        matchMaker.sendInviteDeclined(invitePopup.opponent)
                        invitePopup.close()
                    }
                }
            }
        }
        background: Rectangle {
            anchors.fill: parent
            color: "transparent"
            radius: 20 * root.scaleRatio
        }
    }

    MatchMaker {
        id: matchMaker
        objectName: "matchMaker"
        property var players: []
        onOnlinePlayerFound: {
            var button = Qt.createQmlObject("import QtQuick.Controls 2.4; RoundButton{}", column, "");
            button.text = newPlayer
            button.font.pixelSize = 40 * root.scaleRatio
            button.Layout.alignment = Qt.AlignHCenter
            button.radius = 10 * root.scaleRatio
            button.onPressed.connect(handlePress)
            players.push(button)
            root.rows += 1

            function handlePress() {
                matchMaker.sendGameInvite(newPlayer)
            }
        }
        onOnlinePlayerRemoved: {
            players.forEach(findPlayer)
            function findPlayer(player)
            {
                if (player.text === removedPlayer)
                {
                    player.destroy()
                }
            }
        }
        onGameInvite: {
            invitePopup.opponent = opponentName
            invitePopup.open()
        }
        onGameApproved: {
            stack.push(game)
            root.close()
        }
    }
}






/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

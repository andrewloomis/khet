import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import khet.gamemanager 1.0
//import QtQuick.Window 2.11

Page {
    id: gamePage
    function reset() {
        redStats.pyramidsKilled = 0
        redStats.obelisksKilled = 0
        greyStats.pyramidsKilled = 0
        greyStats.obelisksKilled = 0
        gameManager.reset()
        board.reset()
    }

    ColumnLayout {
        anchors.fill: parent
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: childrenRect.height + 30
            RoundButton {
                text: "Back"
                font.pixelSize: 50
                padding: 20
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20
                onPressed: {
                    stack.pop()
                    gamePage.reset()
                }
            }

            Text {
                id: titleTe//    onActiveFocusChanged: {
                //        if (root.activeFocus)
                //        {
                //            GameLoader.loadGame(gameManager.getPiecePositions())
                //        }
                //    }xt
                anchors.centerIn: parent
                text: ""
                font.pixelSize: 70
                horizontalAlignment: Text.AlignHCenter
            }
            color: "darkgrey"
        }

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Rectangle {
                id: redStats
                property int pyramidsKilled: 0
                property int obelisksKilled: 0

                Layout.margins: 30
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "#770000"
                opacity: 0.9
                ColumnLayout {
                    anchors.fill: parent
                    Text {
                        id: redPanelText
                        color: "white"
                        text: ""
                        clip: true
                        wrapMode: Text.Wrap
                        font.pixelSize: 50
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }
                    Text {
                        id: redPiecesKilledList
                        color: "lightgrey"
                        text: "Pieces killed:\nPyramid: " + redStats.pyramidsKilled
                            + "\nObelisks: " + redStats.obelisksKilled
                        clip: true
                        wrapMode: Text.Wrap
                        font.pixelSize: 50
                        Layout.leftMargin: 20
                        horizontalAlignment: Text.AlignLeft
                        Layout.fillWidth: true
                    }
                }
            }

            Board {
                id: board
                gameManager: gameManager
                rotation: gameManager.myColor == "red" ? 180 : 0
//                x: (appWindow.width-board.width*scale.xScale)/2
//                y: (appWindow.height-board.height*scale.yScale)/2
//                transform: Scale {
//                        id: scale
//                    xScale: Math.min(
//                                appWindow.width/board.width,
//                                appWindow.height/board.height)*.85
//                    yScale: Math.min(
//                                appWindow.width/board.width,
//                                appWindow.height/board.height)*.85
//                    }
            }

            Rectangle {
                id: greyStats
                property int pyramidsKilled: 0
                property int obelisksKilled: 0

                Layout.margins: 30
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: "silver"
                opacity: 0.9
                ColumnLayout {
                    anchors.fill: parent
                    Text {
                        id: greyPanelText
                        color: "black"
                        text: ""
                        clip: true
                        wrapMode: Text.Wrap
                        font.pixelSize: 50
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }

                    Text {
                        id: greyPiecesKilledList
                        color: "#444444"
                        text: "Pieces killed:\nPyramid: " + greyStats.pyramidsKilled
                            + "\nObelisks: " + greyStats.obelisksKilled
                        clip: true
                        wrapMode: Text.Wrap
                        font.pixelSize: 50
                        Layout.leftMargin: 20
                        horizontalAlignment: Text.AlignLeft
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }

    Popup {
        id: winnerPopup
        dim: true
        height: parent.height/6
        width: parent.width/4
        anchors.centerIn: parent
        Rectangle {
            anchors.fill: parent
            anchors.margins: 20
            color: "silver"
            radius: 30
            Text {
                id: winnerPopup_text
                text: ""
                font.pixelSize: 40
                anchors.fill: parent
                anchors.margins: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        background: Rectangle {
            anchors.fill: parent
            radius: 30
            color: "grey"
            opacity: 0.9
        }
        onClosed: {
            stack.pop()
            gamePage.reset()
        }
    }

    background: Rectangle {
        color: "grey"
    }

    GameManager {
        id: gameManager
        objectName: "gameManager"
        onPieceKilled: {
            board.killPiece(index)
            switch(type)
            {
            case "pyramid":
                color == "red" ? redStats.pyramidsKilled += 1 :
                                 greyStats.pyramidsKilled += 1
                break
            case "obelisk":
                color == "red" ? redStats.obelisksKilled += 1 :
                                 greyStats.obelisksKilled += 1
                break
            }
        }
        onUnstackPiece: {
            board.unstackPiece(index, color)
        }

        onModeChanged: {
            if (mode === "sandbox")
            {
                titleText.text = "You vs. Yourself..."
            }
            else
            {
                titleText.text = me + " vs. " + opponent
            }
        }
        onMyColorChanged: {
            board.rotation = myColor == "red" ? 180 : 0
            greyPanelText.text = gameManager.myColor == "grey" ?
                        gameManager.me : gameManager.opponent
            redPanelText.text = gameManager.myColor == "red" ?
                        gameManager.me : gameManager.opponent
        }
        onOpponentPieceMoved: {
            var piece = board.getPiece(index)
            piece.updatePosition(xPos, yPos)
            if (piece.angle !== angle) piece.angle = angle
            board.createOpponentBeam()
        }
        onEndGame: {
            console.log("endgame")
            winnerPopup_text.text = winner + " won!"
            winnerPopup.open()
            console.log("1")
        }
    }
}



















































































/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

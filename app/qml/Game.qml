import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import khet.gamemanager 1.0
//import QtQuick.Window 2.11

Page {
    id: gamePage
    property real scaleRatio: Math.min(appWindow.height/600,
                                         appWindow.width/800) * 0.65
    property int textSize: 50 * scaleRatio

    function reset() {
        redStats.pyramidsKilled = 0
        redStats.obelisksKilled = 0
        greyStats.pyramidsKilled = 0
        greyStats.obelisksKilled = 0
        greyPanelText.text = ""
        redPanelText.text = ""
        titleText.text = ""
        gameManager.lastOpponentPiece.stopHighlightAnimation()
        gameManager.reset()
        board.reset()
    }

    ColumnLayout {
        anchors.fill: parent
        Rectangle {
            id: titleBar
            property int preferredHeight: 100
            property real scaleRatio: (parent.height/preferredHeight)/15

            Layout.fillWidth: true
            Layout.preferredHeight: preferredHeight * scaleRatio * 1.1
            RoundButton {
                text: "Back"
                font.pixelSize: 50 * parent.scaleRatio
                padding: 20 * parent.scaleRatio
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20
                onPressed: {
                    stack.pop()
                    gamePage.reset()
                }
            }

            Text {
                id: titleText
                anchors.centerIn: parent
                text: ""
                font.pixelSize: 70 * gamePage.scaleRatio
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
                Layout.maximumWidth: gamePage.width/6
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
                        font.pixelSize: gamePage.textSize
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
                        font.pixelSize: gamePage.textSize
                        Layout.leftMargin: 20 * scaleRatio
                        horizontalAlignment: Text.AlignLeft
                        Layout.fillWidth: true
                    }
                }
            }
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                z: -1
                Board {
                    anchors.centerIn: parent
                    id: board
                    gameManager: gameManager
                    rotation: gameManager.myColor == "red" ? 180 : 0
                    property real scaleRatio: Math.min(appWindow.height*0.85/board.height,
                                                       appWindow.width*0.7/board.width)

    //                Layout.preferredWidth: board.width * scaleRatio
    //                Layout.preferredHeight: 500
    //                clip: true
    //                Layout.preferredWidth: board.sourceSize.width * scaleRatio
    //                Layout.preferredHeight: board.sourceSize.height * scaleRatio

    //                x: (appWindow.width-board.width*scale.xScale)/2
    //                y: titleBar.height + 30

                    transform:
                        Scale {
                            id: scale
                            origin.x: board.width/2
                            origin.y: board.height/2
                            xScale: board.scaleRatio
                            yScale: board.scaleRatio
                        }
                }
            }



            Rectangle {
                id: greyStats
                property int pyramidsKilled: 0
                property int obelisksKilled: 0

                Layout.margins: 30
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.maximumWidth: gamePage.width/6
//                Layout.minimumWidth: parent.width/6
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
                        font.pixelSize: gamePage.textSize
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
                        font.pixelSize: gamePage.textSize
                        Layout.leftMargin: 20 * scaleRatio
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
            anchors.margins: 20 * gamePage.scaleRatio
            color: "silver"
            radius: 30 * gamePage.scaleRatio
            Text {
                id: winnerPopup_text
                text: ""
                font.pixelSize: 40 * gamePage.scaleRatio
                anchors.fill: parent
                anchors.margins: 10 * gamePage.scaleRatio
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        background: Rectangle {
            anchors.fill: parent
            radius: 30 * gamePage.scaleRatio
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
        property Piece lastOpponentPiece

        function stopHighlightAnimation() {
            lastOpponentPiece.stopHighlightAnimation()
            lastOpponentPiece = undefined
        }

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
            piece.startHighlightAnimation()
            piece.updatePosition(xPos, yPos)
            if (piece.angle !== angle) {
                piece.rotDir = (angle > piece.angle) ? "CW" : "CCW"
                piece.angle = angle
                gameManager.updatePieceAngle(index, angle)
                console.log("piece", index, "rotating CW to", angle, "degrees")
            }
            board.createOpponentBeam()
            lastOpponentPiece = piece
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

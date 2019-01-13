import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "gameloader.js" as GameLoader
import khet.gamemanager 1.0

Page {
    id: gamePage
    Button {

    }
    Board {
        id: board
        Component.onCompleted: {
            GameLoader.init(board, gameManager)
            GameLoader.loadGame(gameManager.getPiecePositions())
        }
    }

    GameManager {
        id: gameManager

    }

    background: Rectangle {
        color: "grey"
    }

}



















































































/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

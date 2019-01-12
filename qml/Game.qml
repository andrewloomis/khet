import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {
    Button {

    }
    Pyramid {

    }

    Image {
        property string playerColor: "Red"
        id: board
        fillMode: Image.PreserveAspectFit
        source: "res/board.png"
        anchors.centerIn: parent
//        height: 5*parent.height/6
        z: -1
        rotation: {
            if (playerColor === "Red") return 180;
            else if (playerColor === "Grey") return 0;
            else return 0;
        }
    }

    background: Rectangle {
        color: "grey"
    }
}



















































































/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

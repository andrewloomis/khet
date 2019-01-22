import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import khet.matchmaker 1.0

Popup {
    id: root
    dim: true
    height: column.childrenRect.height + 70
    width: column.childrenRect.width + 70
    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: 30
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            height: childrenRect.height + 50
            width: childrenRect.width + 50
            radius: 20
            color: "#605060"
            Text {
                anchors.centerIn: parent
                fontSizeMode: Text.FixedSize
                text: "Finding players online..."
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                font.pixelSize: 50
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
        radius: 20
    }
    MatchMaker {
        id: matchMaker
        objectName: "matchMaker"
        onOnlinePlayerFound: {
            var button = Qt.createQmlObject("import QtQuick.Controls 2.4; RoundButton{}", column, "");
            button.text = newPlayer
            button.font.pixelSize = 40
            button.Layout.alignment = Qt.AlignHCenter
            button.radius = 10
        }
    }
}






/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import khet.loginmanager 1.0

Popup {
    dim: true
    property LoginManager loginManager
    Column {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 40
        RowLayout {
            width: parent.width
            spacing: 50
            Text {
                text: "Username"
                font.pixelSize: 40
                color: "black"
                Layout.preferredWidth: parent.width/3
            }
            TextField {
                font.pointSize: 40
                color: "grey"
                clip: true
                Layout.fillWidth: true
                echoMode: TextInput.Normal
            }
        }
        RowLayout {
            width: parent.width
            spacing: 50
            Text {
                text: "Password"
                font.pixelSize: 40
                color: "black"
                Layout.preferredWidth: parent.width/3
            }
            TextField {
                id: password
                font.pointSize: 40
                color: "grey"
                clip: true
                Layout.fillWidth: true
                echoMode: TextInput.Password
            }
        }
        RoundButton {
            width: parent.width/2
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Login"
            font.pixelSize: 40
            onPressed: {

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





































































/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

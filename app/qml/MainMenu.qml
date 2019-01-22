import QtQuick 2.0
import QtQuick.Controls 2.4
import khet.loginmanager 1.0

Page {
    Column {
        id: column
        anchors.centerIn: parent
        width: parent.width /2
        height: parent.height*0.75
        spacing: 20
        Text {
            id: title
            text: qsTr("Khet")
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 70
            width: parent.width
        }
        Button {
            text: "Play"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 50
            width: parent.width/2
            height: parent.height/8
            onPressed: {
                gameSelectPopup.open()
                //stack.push(game)
            }
        }
        Button {
            text: "Log in"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 50
            width: parent.width/2
            height: parent.height/8
            onPressed: loginPage.open()
        }
        Button {
            text: "Sign Up"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 50
            width: parent.width/2
            height: parent.height/8
            onPressed: signUpPage.open()
        }
        Button {
            text: "Rankings"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 50
            width: parent.width/2
            height: parent.height/8
        }
        Button {
            text: "Settings"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 50
            width: parent.width/2
            height: parent.height/8
        }
        Text {
            id: loginText
            text: "Not logged in"
            font.italic: true
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 30
            width: parent.width
            color: "grey"
        }
        RoundButton {
            id: logoutButton
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Logout"
            onPressed: {
                visible = false
                loginManager.logout()
                loginText.text = "Not logged in"
            }
        }
    }
    MatchMakerPopup {
        id: matchMakerPopup
        anchors.centerIn: parent
    }
    GameSelectPopup {
        id: gameSelectPopup
        anchors.centerIn: parent
    }

    SignUpPage {
        id: signUpPage
        anchors.centerIn: parent
        width: parent.width/2
        loginManager: loginManager
    }
    LoginPage {
        id: loginPage
        anchors.centerIn: parent
        width: parent.width/2
        loginManager: loginManager
    }
    LoginManager {
        id: loginManager
        objectName: "loginManager"
        onLoggedIn: {
            loginText.text = "Logged in as " + username
            logoutButton.visible = true
        }
    }
}

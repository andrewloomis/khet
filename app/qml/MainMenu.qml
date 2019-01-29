import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import khet.loginmanager 1.0

Page {
    Rectangle {
        color: "lightgrey"
        opacity: 0.9
        radius: 30
        anchors.centerIn: parent
        width: parent.width /3
        height: parent.height*0.65

        ColumnLayout {
            id: column
            anchors.margins: 30
            anchors.fill: parent
            spacing: 20
            Text {
                id: title
                text: qsTr("Khet")
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 70
                width: parent.width
                Layout.alignment: Qt.AlignHCenter
            }
            RoundButton {
                text: "Play"
                font.pointSize: 50
                Layout.alignment: Qt.AlignHCenter
                radius: 10
                padding: 20
                onHoveredChanged: {
                    if(hovered)
                    {
                        highlighted = true
                    }
                    else {
                        highlighted = false
                    }
                }
                onPressed: {
                    gameSelectPopup.open()
                }
            }
            RoundButton {
                text: "Log in"
                font.pointSize: 50
                Layout.alignment: Qt.AlignHCenter
                radius: 10
                padding: 20
                onHoveredChanged: {
                    if(hovered)
                    {
                        highlighted = true
                    }
                    else {
                        highlighted = false
                    }
                }
                onPressed: loginPage.open()
            }
            RoundButton {
                text: "Sign Up"
                font.pointSize: 50
                Layout.alignment: Qt.AlignHCenter
                radius: 10
                padding: 20
                onHoveredChanged: {
                    if(hovered)
                    {
                        highlighted = true
                    }
                    else {
                        highlighted = false
                    }
                }
                onPressed: signUpPage.open()
            }
            Text {
                id: loginText
                text: "Not logged in"
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 30
                width: parent.width
                color: "grey"
                Layout.alignment: Qt.AlignHCenter
            }
            RoundButton {
                id: logoutButton
                visible: false
                font.pixelSize: 30
                Layout.alignment: Qt.AlignHCenter
                text: "Logout"
                onPressed: {
                    visible = false
                    loginManager.logout()
                    loginText.text = "Not logged in"
                }
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
    function isLoggedIn()
    {
        return loginManager.isLoggedIn()
    }

    LoginManager {
        id: loginManager
        objectName: "loginManager"
        onLoggedIn: {
            loginText.text = "Logged in as " + username
            logoutButton.visible = true
        }
    }
    background: Image {
        anchors.fill: parent
        source: "res/mainmenuimage.png"
        fillMode: Image.PreserveAspectCrop
    }
}

import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import khet.usermanager 1.0

Page {
    Rectangle {
        id: background
        property int preferredHeight: 900
        property int preferredWidth: 600
        property real scaleRatio: Math.min(appWindow.width/preferredWidth,
                                           appWindow.height/preferredHeight) * 0.8;
        color: "lightgrey"
        opacity: 0.9
        radius: 30
        anchors.centerIn: parent
        width: preferredWidth * scaleRatio
        height: preferredHeight * scaleRatio

        ColumnLayout {
            id: column
            anchors.margins: 30 * background.scaleRatio
            anchors.fill: parent
            spacing: 20 * background.scaleRatio
            clip: true
            Text {
                id: title
                text: qsTr("Khet")
                font.family: "Ubuntu"
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 70 * background.scaleRatio
                width: parent.width
                Layout.alignment: Qt.AlignHCenter
            }
            RoundButton {
                text: "Play"
                font.family: "Ubuntu"
                font.pointSize: 50 * background.scaleRatio
                Layout.alignment: Qt.AlignHCenter
                radius: 10
                padding: 20 * background.scaleRatio
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
                font.family: "Ubuntu"
                font.pointSize: 50 * background.scaleRatio
                Layout.alignment: Qt.AlignHCenter
                radius: 10
                padding: 20 * background.scaleRatio
                onHoveredChanged: {
                    if(hovered)
                    {
                        highlighted = true
                    }
                    else {
                        highlighted = false
                    }
                }
                onPressed: if (!isLoggedIn()) loginPage.open()
            }
            RoundButton {
                text: "Sign Up"
                font.family: "Ubuntu"
                font.pointSize: 50 * background.scaleRatio
                Layout.alignment: Qt.AlignHCenter
                radius: 10
                padding: 20 * background.scaleRatio
                onHoveredChanged: {
                    if(hovered)
                    {
                        highlighted = true
                    }
                    else {
                        highlighted = false
                    }
                }
                onPressed: if (!isLoggedIn()) signUpPage.open()
            }
            RoundButton {
                text: "Rankings"
                font.family: "Ubuntu"
                font.pointSize: 50 * background.scaleRatio
                Layout.alignment: Qt.AlignHCenter
                radius: 10
                padding: 20 * background.scaleRatio
                onHoveredChanged: {
                    if(hovered)
                    {
                        highlighted = true
                    }
                    else {
                        highlighted = false
                    }
                }
                onPressed: if(isLoggedIn()) rankingsPopup.open()
            }
            Text {
                id: loginText
                text: "Not logged in"
                font.family: "Ubuntu"
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 30 * background.scaleRatio
                width: parent.width
                color: "grey"
                Layout.alignment: Qt.AlignHCenter
            }
            RoundButton {
                id: logoutButton
                visible: false
                font.pixelSize: 30 * background.scaleRatio
                padding: 5 * background.scaleRatio
                radius: 10 * background.scaleRatio
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignHCenter
                text: "Logout"
                font.family: "Ubuntu"
                onPressed: {
                    visible = false
                    userManager.logout()
                    loginText.text = "Not logged in"
                }
            }
        }
    }
    RankingsPopup {
        id: rankingsPopup
        anchors.centerIn: parent
        userManager: userManager
        scaleRatio: background.scaleRatio
    }

    MatchMakerPopup {
        id: matchMakerPopup
        anchors.centerIn: parent
        scaleRatio: background.scaleRatio
    }
    GameSelectPopup {
        id: gameSelectPopup
        anchors.centerIn: parent
        scaleRatio: background.scaleRatio
    }
    SignUpPage {
        id: signUpPage
        anchors.centerIn: parent
        width: 3*parent.width/4
        userManager: userManager
        scaleRatio: background.scaleRatio
    }
    LoginPage {
        id: loginPage
        anchors.centerIn: parent
        width: parent.width/2
        userManager: userManager
        scaleRatio: background.scaleRatio
    }
    function isLoggedIn()
    {
        return userManager.isLoggedIn()
    }

    UserManager {
        id: userManager
        objectName: "userManager"
        onLoggedIn: {
            loginText.text = "Logged in as " + username
            logoutButton.visible = true
        }
        onRankingsReceived: {
            rankingsPopup.updateRankings(rankings)
        }
    }
    background: Image {
        anchors.fill: parent
        source: "res/mainmenuimage.png"
        fillMode: Image.PreserveAspectCrop
    }
}

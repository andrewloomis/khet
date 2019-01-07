import QtQuick 2.9
import QtQuick.Controls 2.4

ApplicationWindow {
    visible: true
    width: 1920
    height: 1080
    title: qsTr("Khet")

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
            onPressed: matchMaker.open()
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
            text: "Not logged in"
            font.italic: true
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 30
            width: parent.width
            color: "grey"
        }
    }
    MatchMaker {
        id: matchMaker
        anchors.centerIn: parent
        width: parent.width/2
        height: parent.height*0.75
    }
    SignUpPage {
        id: signUpPage
        anchors.centerIn: parent
        width: parent.width/2
        height: parent.height*0.55
    }
    LoginPage {
        id: loginPage
        anchors.centerIn: parent
        width: parent.width/2
        height: parent.height*0.35
    }
}

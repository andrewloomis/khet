import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import khet.usermanager 1.0
Popup {
    id: root
    dim: true
    height: column.childrenRect.height + 70
    property UserManager userManager
    property real scaleRatio

    Column {
        id: column
        anchors.fill: parent
        anchors.margins: 30 * scaleRatio
        spacing: 40 * scaleRatio
        Text {
            text: "Sign Up"
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            width: parent.width
            font.pixelSize: 50 * scaleRatio
        }
        RowLayout {
            width: parent.width
            spacing: 50 * scaleRatio
            Text {
                text: "Username"
                font.pixelSize: 40 * scaleRatio
                color: "black"
                Layout.preferredWidth: parent.width/3
            }
            TextField {
                id: usernameField
                font.pointSize: 40 * scaleRatio
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
                font.pixelSize: 40 * scaleRatio
                color: "black"
                Layout.preferredWidth: parent.width/3
            }
            TextField {
                id: passwordField
                font.pointSize: 40 * scaleRatio
                color: "grey"
                clip: true
                Layout.fillWidth: true
                echoMode: TextInput.Password
            }
        }
        RowLayout {
            width: parent.width
            spacing: 50 * scaleRatio
            Text {
                text: "Confirm Password"
                font.pixelSize: 35 * scaleRatio
                color: "black"
                Layout.preferredWidth: parent.width/3
            }
            TextField {
                id: confirmPasswordField
                font.pointSize: 40 * scaleRatio
                color: "grey"
                clip: true
                Layout.fillWidth: true
                echoMode: TextInput.Password
            }
        }

        Text {
            id: warningText
            visible: false
            text: "warning"
            height: (parent.height/13) * scaleRatio
            font.pixelSize: 35 * scaleRatio
            color: "red"
            anchors.horizontalCenter: parent.horizontalCenter
            textFormat: Text.AlignHCenter
        }

        RoundButton {
            id: button
            property color backgroundColor: "white"

            width: parent.width/2
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Done"
            contentItem: Text {
                id: buttonText
                text: parent.text
//                color: parent.textColor
                font.pixelSize: 40 * scaleRatio
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

            }
            clip: true
            onPressed: {
                if (passwordField.text != confirmPasswordField.text)
                {
                    warningText.text = "passwords do not match!"
                    warningText.visible = true
                }
                else if (passwordField.text.length < 6)
                {
                    warningText.text = "password must be at least 6 characters!"
                    warningText.visible = true
                }

                else
                {
                    warningText.visible = false
                    state = "waiting"
                    userManager.registerUser(usernameField.text, passwordField.text)
                }
                passwordField.text = ""
                confirmPasswordField.text = ""
            }
            onHoveredChanged: {
                if (hovered)
                {
                    button.backgroundColor = "lightblue"
                }
                else {
                    button.backgroundColor = "white"
                }
            }

            states: State {
                name: "waiting"
                PropertyChanges {
                    target: button
                    backgroundColor: "blue"
                }
                StateChangeScript {
                    script: {
                        waitTimer.start()
                    }
                }
            }
            transitions: Transition {
                ColorAnimation {
                    duration: 1500
                }
            }

            Timer {
                id: waitTimer
                interval: 1500
                onTriggered: {
                    parent.state = ""
                    if (!userManager.isLoggedIn())
                    {
                        warningText.text = "username already taken!"
                        warningText.visible = true
                        usernameField.text = ""
                    }
                    else {
                        usernameField.text = ""
                        root.close()
                    }
                }
            }

            background: Rectangle {
                radius: parent.radius
                color: parent.backgroundColor
//                opacity: 0.7
            }
        }


    }

    background: Rectangle {
        anchors.fill: parent
        color: "grey"
        opacity: 0.95
        radius: 40 * scaleRatio
        z: -1
    }
}



































































/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

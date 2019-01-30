import QtQuick 2.12
//import QtQuick.Controls 1.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import khet.usermanager 1.0

Popup {
    id: root
    property UserManager userManager

    dim: true
    height: parent.height/2
    width: parent.width/2
    Rectangle {
        id: rect
        anchors.fill: parent
        anchors.margins: 10
        radius: 20
        color: "#605060"
        ColumnLayout {
            anchors.fill: parent
            Text {
                id: header
                text: "Rankings"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.bottomMargin: 20
                font.pixelSize: 50
            }
            Rectangle {
                implicitWidth: parent.width - 40
                implicitHeight: 50
                Layout.alignment: Qt.AlignHCenter
                radius: 5
                RowLayout {
                    anchors.fill: parent
                    Text {
                        Layout.preferredWidth: parent.width/3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "Users"
                        font.pixelSize: 40
                        color: "darkred"
                    }
                    Text {
                        Layout.preferredWidth: parent.width/3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "Wins"
                        font.pixelSize: 40
                        color: "darkred"
                    }
                    Text {
                        Layout.preferredWidth: parent.width/3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "Losses"
                        font.pixelSize: 40
                        color: "darkred"
                    }
                }
            }


            TableView {
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width - 40
                clip: true
                rowSpacing: 2

                model: rankingsModel
                delegate: Rectangle {
                    implicitWidth: parent.width
                    implicitHeight: 50
                    radius: 5
                    RowLayout {
                        anchors.fill: parent
                        Text {
                            Layout.preferredWidth: parent.width/3
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: user
                            font.pixelSize: 40
                        }
                        Text {
                            Layout.preferredWidth: parent.width/3
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: wins
                            font.pixelSize: 40
                        }
                        Text {
                            Layout.preferredWidth: parent.width/3
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: losses
                            font.pixelSize: 40
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: rankingsModel
    }

    function updateRankings(list)
    {
        rankingsModel.clear()
        for(var i = 0; i < list.length; i+=3)
        {
            rankingsModel.append({"user": list[i], "wins": Number(list[i+1]), "losses": Number(list[i+2])})
        }
    }

    onOpened: {
        userManager.getRankings()
//        rankingsModel.append({"user": "test", "wins": 0, "losses": 2})
    }
    background: Rectangle {
        anchors.fill: parent
        color: "lightgrey"
        radius: 20
    }
}

import QtQuick 2.12
//import QtQuick.Controls 1.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import khet.usermanager 1.0

Popup {
    id: root
    property UserManager userManager
    property real scaleRatio

    dim: true
    height: 3*parent.height/4
    width: 3*parent.width/4

    Rectangle {
        id: rect
        anchors.fill: parent
        anchors.margins: 10 * root.scaleRatio
        radius: 20 * root.scaleRatio
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
                Layout.topMargin: 20 * root.scaleRatio
                Layout.bottomMargin: 20 * root.scaleRatio
                font.pixelSize: 50 * root.scaleRatio
            }
            Rectangle {
                implicitWidth: parent.width - 40 * root.scaleRatio
                implicitHeight: 50 * root.scaleRatio
                Layout.alignment: Qt.AlignHCenter
                radius: 5 * root.scaleRatio
                RowLayout {
                    anchors.fill: parent
                    Text {
                        Layout.preferredWidth: parent.width/3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "Users"
                        font.pixelSize: 40 * root.scaleRatio
                        color: "darkred"
                    }
                    Text {
                        Layout.preferredWidth: parent.width/3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "Wins"
                        font.pixelSize: 40 * root.scaleRatio
                        color: "darkred"
                    }
                    Text {
                        Layout.preferredWidth: parent.width/3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "Losses"
                        font.pixelSize: 40 * root.scaleRatio
                        color: "darkred"
                    }
                }
            }


            TableView {
                id: table
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: parent.width - (40 * root.scaleRatio)
                clip: true
                rowSpacing: 2

                model: rankingsModel
                delegate: Rectangle {
                    implicitWidth: rect.width - (40 * root.scaleRatio)
                    implicitHeight: 50 * root.scaleRatio
                    radius: 5 * root.scaleRatio
                    RowLayout {
                        anchors.fill: parent
                        Text {
                            Layout.preferredWidth: parent.width/3
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: user
                            font.pixelSize: 40 * root.scaleRatio
                        }
                        Text {
                            Layout.preferredWidth: parent.width/3
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: wins
                            font.pixelSize: 40 * root.scaleRatio
                        }
                        Text {
                            Layout.preferredWidth: parent.width/3
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: losses
                            font.pixelSize: 40 * root.scaleRatio
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: rankingsModel
    }
    onScaleRatioChanged: {
        table.forceLayout()
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
        radius: 20 * root.scaleRatio
    }
}

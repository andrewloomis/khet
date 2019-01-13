import QtQuick 2.0

Item {
    property Item piece;
    property int location: 0

    id: root
    width: 90
    height: 90
    anchors.margins: 10
    Image {
        source: "res/circle.png"
        anchors.centerIn: parent
        width: 45
        height: 45
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            switch(location)
            {
            case 1:
                piece.updatePosition(piece.xPos-1, piece.yPos-1)
                break;
            case 2:
                piece.updatePosition(piece.xPos, piece.yPos-1)
                break;
            case 3:
                piece.updatePosition(piece.xPos+1, piece.yPos-1)
                break;
            case 4:
                piece.updatePosition(piece.xPos-1, piece.yPos)
                break;
            case 6:
                piece.updatePosition(piece.xPos+1, piece.yPos)
                break;
            case 7:
                piece.updatePosition(piece.xPos-1, piece.yPos+1)
                break;
            case 8:
                piece.updatePosition(piece.xPos, piece.yPos+1)
                break;
            case 9:
                piece.updatePosition(piece.xPos+1, piece.yPos+1)
                break;
            }
        }
    }

    states: [
        State {
            name: "retracted"
            PropertyChanges { target: root;  location: 0 }
            AnchorChanges {
                target: root
                anchors.right: piece.right
                anchors.bottom: piece.bottom
            }
        },
        State {
            name: "deployTopLeft"
            PropertyChanges { target: root;  location: 1 }
            AnchorChanges {
                target: root
                anchors.right: piece.left
                anchors.bottom: piece.top
            }
        },
        State {
            name: "deployTop"
            PropertyChanges { target: root;  location: 2 }
            AnchorChanges {
                target: root
                anchors.horizontalCenter: piece.horizontalCenter
                anchors.bottom: piece.top
            }
        },
        State {
            name: "deployTopRight"
            PropertyChanges { target: root;  location: 3 }
            AnchorChanges {
                target: root
                anchors.left: parent.right
                anchors.bottom: parent.top
            }
        },
        State {
            name: "deployLeft"
            PropertyChanges { target: root;  location: 4 }
            AnchorChanges {
                target: root
                anchors.right: piece.left
                anchors.verticalCenter: piece.verticalCenter
            }
        },
        State {
            name: "deployRight"
            PropertyChanges { target: root;  location: 6 }
            AnchorChanges {
                target: root
                anchors.left: piece.right
                anchors.verticalCenter: piece.verticalCenter
            }
        },
        State {
            name: "deployBottomLeft"
            PropertyChanges { target: root;  location: 7 }
            AnchorChanges {
                target: root
                anchors.right: piece.left
                anchors.top: piece.bottom
            }
        },
        State {
            name: "deployBottom"
            PropertyChanges { target: root;  location: 8 }
            AnchorChanges {
                target: root
                anchors.horizontalCenter: piece.horizontalCenter
                anchors.top: piece.bottom
            }
        },
        State {
            name: "deployBottomRight"
            PropertyChanges { target: root;  location: 9 }
            AnchorChanges {
                target: root
                anchors.left: piece.right
                anchors.top: piece.bottom
            }
        }
    ]

    transitions: Transition {
        AnchorAnimation {
            duration: 200
        }
        onRunningChanged: {
            if (state == "retracted" && !running)
            {
                root.destroy()
            }
        }
    }
}

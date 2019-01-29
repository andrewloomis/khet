import QtQuick 2.9
import QtQuick.Controls 2.4

ApplicationWindow {
    id: appWindow
    visible: true
    width: 1920
    height: 1080
    title: qsTr("Khet")

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: mainMenu
        Game {
            id: game
            anchors.fill: parent
        }
        MainMenu {
            id: mainMenu
            anchors.fill: parent
        }
    }
}

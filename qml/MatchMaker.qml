import QtQuick 2.0
import QtQuick.Controls 2.4

Popup {
    dim: true
    Column {
        anchors.fill: parent
        anchors.margins: 30
        Text {
            text: "Finding players online..."
            horizontalAlignment: Text.AlignHCenter
            color: "blue"
            width: parent.width
            font.pixelSize: 50
        }
    }

    background: Rectangle {
        anchors.fill: parent
        color: "grey"
        opacity: 0.8
        radius: 40
    }
}






/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

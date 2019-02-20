import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Popup {
    id: root
    dim: true
    height: 1000 * root.scaleRatio
    width: 1000 * root.scaleRatio
    property real scaleRatio
    ScrollView {
        anchors.fill: parent
        clip: true
        ColumnLayout {
            width: parent.width
            height: 4000 * scaleRatio
            Image {
                Layout.alignment: Qt.AlignLeft
                source: "res/khetrules1.png"
                fillMode: Image.PreserveAspectFit
                width: sourceSize.width * scaleRatio
                height: sourceSize.height * scaleRatio
            }
            Image {
                Layout.alignment: Qt.AlignLeft
                source: "res/khetrules2.png"
                fillMode: Image.PreserveAspectFit
                width: sourceSize.width * scaleRatio
                height: sourceSize.height * scaleRatio
            }
            Image {
                Layout.alignment: Qt.AlignLeft
                source: "res/khetrules3.png"
                fillMode: Image.PreserveAspectFit
                width: sourceSize.width * scaleRatio
                height: sourceSize.height * scaleRatio
            }
        }
    }
}

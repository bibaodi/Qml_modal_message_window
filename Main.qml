import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    id: id_crashInfoWindow
    width: 1920
    height: 1080
    visible: true
    visibility: Window.FullScreen
    modality: Qt.WindowModal

    Rectangle {
        id: id_background
        color: 'blue'
        anchors.fill: parent
    }
    title: qsTr("SIHO INFORMATION")

    Item {
        id: id_textsColumn
        width: parent.width
        height: parent.height

        function repeatChar(chars, times) {
            let resultStr = ''
            for (var i = 0; i < times; i++)
                resultStr += chars

            return resultStr
        }

        Text {
            id: id_headerTitle
            //x: 0.3 * parent.width
            y: 0.2 * parent.height

            //anchors.centerIn: id_textsColumn
            height: 200
            anchors.horizontalCenter: id_textsColumn.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            property string splitLine: id_textsColumn.repeatChar('-', 32)
            text: splitLine + '\n' + messageLevel + '\n' + splitLine
            font.pointSize: 54
            color: "red"
            wrapMode: Text.WordWrap
        }
        Text {
            id: id_headerMessage
            width: id_textsColumn.width * 0.9
            anchors.centerIn: id_textsColumn
            horizontalAlignment: Text.AlignHCenter
            text: displayText
            font.pointSize: 24
            color: "red"
            wrapMode: Text.WordWrap
        }

        Button {
            id: id_shutdownMachine
            anchors.horizontalCenter: id_textsColumn.horizontalCenter
            width: id_textsColumn.width * 0.1
            y: id_headerMessage.y + id_headerMessage.height + 200
            text: "power off"
            font.pointSize: 24
            onClicked: {
                qmlSystemProcessCaller.poweroff("user click button")
                id_modaldialog.visible = true
            }
        }
    }
    onActiveFocusItemChanged: {
        //console.log("activeFocusItemChanged, active=", active)
        requestActivate()
        if (false === active) {
            qmlSystemProcessCaller.poweroff("lose focus")
        }
    }
    Dialog {
        id: id_modaldialog
        modal: true
        width: 800
        height: 600

        visible: false
        standardButtons: Dialog.Ok
    }
}

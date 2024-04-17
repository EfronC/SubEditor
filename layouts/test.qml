import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {
    width: 800
    height: 800

    ColumnLayout {
        anchors.fill: parent

        Button {
            objectName: "add"
            text: "Replace line"
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width * 0.45 // 30% width
            signal messageRequired
            onClicked: {
                var component;
                var sprite;
                component = Qt.createComponent("action.qml");
                sprite = component.createObject(actions, {"x": 100, "y": 100});
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height * 0.4 // 30% width

            ColumnLayout {
                id: actions
                objectName: "actions"
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
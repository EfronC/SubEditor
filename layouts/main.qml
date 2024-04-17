import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import mpvtest 1.0

Item {
    width: 1920
    height: 1080

    RowLayout {
        anchors.fill: parent

        // Left side
        ColumnLayout {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.7

            /*
            MpvObject {
                id: renderer
                Layout.fillWidth: true
                Layout.preferredHeight: parent.parent.height * 0.8

                MouseArea {
                    anchors.fill: parent
                    onClicked: renderer.play("./videos/sample.mkv")
                }
            }
            */

            MpvFrame {
                id: mpvframe
                Layout.fillWidth: true
                Layout.preferredHeight: parent.parent.height * 0.8
            }

            Rectangle {
                color: "#DDDDDD"
                Layout.fillWidth: true
                Layout.preferredHeight: parent.parent.height * 0.2

                Label {
                    objectName: "subtitle"
                    text: "Placeholder"
                    wrapMode: Text.Wrap
                    font.pixelSize: 20
                    color: "black"
                    anchors.centerIn: parent
                }
            }
        }

        // Right side
        ColumnLayout {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.3

            // First row with 3 buttons
            /*
            Slider {
                objectName: "position"
                Layout.fillWidth: true
                Layout.margins: parent.height * 0.01 // 5% margin top and bottom
                value: 50
                minimumValue: 0
                maximumValue: 100
            }

            // Second row with a slider
            RowLayout {
                spacing: parent.width * 0.05 // 5% spacing
                Layout.margins: parent.height * 0.03 // 5% margin top and bottom

                Button {
                    text: "<<"
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width * 0.3 // 30% width
                }
                Button {
                    text: "▶/▐▐"
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width * 0.3 // 30% width
                }
                Button {
                    text: ">>"
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width * 0.3 // 30% width
                }
            }
            */

            // Third row with another rectangle
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // First row with an editable text line
                TextField {
                    placeholderText: "Enter text..."
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                }

                // Second row with two buttons
                RowLayout {
                    spacing: parent.width * 0.1 // 5% spacing
                    Layout.margins: parent.height * 0.03 // 5% margin top and bottom

                    Button {
                        objectName: "replaceL"
                        text: "Replace line"
                        Layout.fillWidth: true
                        Layout.preferredWidth: parent.width * 0.45 // 30% width
                        signal messageRequired
                        onClicked: {
                            var component;
                            var sprite;
                            component = Qt.createComponent("action.qml");
                            sprite = component.createObject(actions, {"objectName": "ActionRow"});
                        }
                    }
                    Button {
                        objectName: "replaceA"
                        text: "Replace All"
                        Layout.fillWidth: true
                        Layout.preferredWidth: parent.width * 0.45 // 30% width
                    }
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

            ColumnLayout {
                Layout.margins: parent.height * 0.03 // 5% margin top and bottom

                Button {
                    text: "Generate File"
                    Layout.fillWidth: true
                }

                Button {
                    objectName: "close"
                    text: "Close App"
                    Layout.fillWidth: true
                    signal closeApp
                    onClicked: closeApp()
                }
            }

            Image {
                source: Qt.resolvedUrl("./sample.png")
                fillMode: Image.PreserveAspectFit
                Layout.fillWidth: true
                Layout.fillHeight: true
                //Layout.preferredHeight: 200 // Set the preferred height of the image
            }

            /*
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "lightcoral"
            }
            */
        }
    }
}
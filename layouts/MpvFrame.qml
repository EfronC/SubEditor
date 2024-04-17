import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import mpvtest 1.0

Item {
    MpvObject {
        id: renderer
        anchors.fill: parent

        MouseArea {
            id: ma
            hoverEnabled: true
            property bool hovered: false
            onEntered: hovered = true
            onExited: hovered = false
            anchors.fill: parent
            onClicked: renderer.play("./videos/sample.mkv")
        }
    }

    Rectangle {
        id: labelFrame
        anchors.margins: -50
        radius: 5
        color: "white"
        border.color: "black"
        opacity: 0.6
        anchors.fill: box
        property bool folded: ma.hovered || ma.hovered
        /*
        //visible: ma.hovered || ma.hovered

        states: [
            State { when: labelFrame.folded; 
                    PropertyChanges {   target: labelFrame; opacity: 0.6    }},
            State { when: !labelFrame.folded;
                    PropertyChanges {   target: labelFrame; opacity: 0.0    }}
        ]
        transitions: [ Transition { NumberAnimation { property: "opacity"; duration: 500}} ]
        */
    }

    Row {
        id: box
        anchors.bottom: renderer.bottom
        anchors.left: renderer.left
        anchors.right: renderer.right
        anchors.margins: 100
        /*
        property bool folded: ma.hovered || ma.hovered
        //visible: ma.hovered || ma.hovered

        states: [
            State { when: box.folded; 
                    PropertyChanges {   target: box; opacity: 1.0    }},
            State { when: !box.folded;
                    PropertyChanges {   target: box; opacity: 0.0    }}
        ]
        transitions: [ Transition { NumberAnimation { property: "opacity"; duration: 500}} ]
        */

        // Don't take these controls too seriously. They're for testing.
        Column {
            anchors.centerIn: parent
            Layout.fillWidth: true

            Slider {
                objectName: "position"
                id: slider
                width: 1000
                value: 0
                minimumValue: 0
                maximumValue: 100
            }

            // Second row with a slider
            Row {
                spacing: parent.width * 0.05 // 5% spacing
                anchors.horizontalCenter: parent.horizontalCenter
                Layout.margins: parent.height * 0.03 // 5% margin top and bottom

                Button {
                    id: backward
                    text: "<<"
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width * 0.3 // 30% width
                }
                Button {
                    id: pp
                    text: "▶/▐▐"
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width * 0.3 // 30% width
                }
                Button {
                    id: forward
                    text: ">>"
                    Layout.fillWidth: true
                    Layout.preferredWidth: parent.width * 0.3 // 30% width
                }
            }
        }
    }
}

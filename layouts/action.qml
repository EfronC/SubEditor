import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

// Empty for now, you can add rows dynamically here
RowLayout {
	id: act
    spacing: parent.width * 0.02 // 5% spacing
    Layout.fillWidth: true

    // Radio button occupying 10% of the space
    RadioButton {
        Layout.fillWidth: true
        Layout.preferredWidth: 10
    }

    // Push button occupying 10% of the space
    Button {
        Layout.fillWidth: true
        Layout.preferredWidth: 20
        text: "X"
        onClicked: {
            act.destroy()
        }
    }

    // Label occupying 80% of the space
    Label {
        Layout.fillWidth: true
        Layout.preferredWidth: 300
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"
    }
}
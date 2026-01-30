import QtQuick

Rectangle {
    id: dockIcon

    property var settings: null
    property var dockRef: null
    property var appLaunchRef: null
    property var toplevel: null

    property string iconText: ""
    property string appName: ""
    property string appId: ""
    property string command: ""
    property bool isPinned: false
    property bool isRunning: false
    property bool isHovered: false

    width: 48
    height: 48
    radius: settings ? settings.radiusSmall : 10
    color: isHovered ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
    scale: isHovered ? 1.12 : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutBack
            easing.overshoot: 1.3
        }
    }

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    Text {
        anchors.centerIn: parent
        text: iconText
        font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
        font.pixelSize: settings ? settings.fontSizeIcon + 4 : 22
        color: settings ? settings.colorText : "#cdd6f4"
    }

    Rectangle {
        id: tooltip
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 6
        height: 22
        width: tooltipText.implicitWidth + 16
        radius: 6
        color: settings ? settings.colorBackgroundAlt : "#313244"
        border.width: 1
        border.color: settings ? settings.colorBorder : "#585b70"
        opacity: isHovered ? 1 : 0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation { duration: 120 }
        }

        Text {
            id: tooltipText
            anchors.centerIn: parent
            text: appName
            font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
            font.pixelSize: settings ? settings.fontSizeLabel - 1 : 11
            color: settings ? settings.colorText : "#cdd6f4"
        }
    }

    Rectangle {
        anchors.top: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 4
        width: 6
        height: 6
        radius: 3
        color: settings ? settings.colorAccent : "#89b4fa"
        visible: isRunning
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            dockIcon.isHovered = true
            if (dockRef) dockRef.onIconHoverChanged(true)
        }
        onExited: {
            dockIcon.isHovered = false
            if (dockRef) dockRef.onIconHoverChanged(false)
        }

        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                if (dockRef) dockRef.togglePinFromApp(appId)
                return
            }

            if (toplevel) {
                toplevel.activate()
                return
            }

            if (command && command.length > 0 && appLaunchRef) {
                appLaunchRef.command = ["sh", "-c", command]
                appLaunchRef.startDetached()
            }
        }
    }
}

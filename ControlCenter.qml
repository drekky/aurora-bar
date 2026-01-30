import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

WlrLayershell {
    id: controlCenter

    // References passed from shell.qml
    property var settings: null
    property var settingsPanel: null

    property bool panelVisible: false

    function toggle() {
        panelVisible = !panelVisible
    }

    function show() {
        panelVisible = true
    }

    function hide() {
        panelVisible = false
    }

    layer: WlrLayer.Overlay
    exclusiveZone: 0
    namespace: "control-center"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"
    visible: panelVisible

    // Background overlay (click to close)
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: panelVisible ? 0.5 : 0

        Behavior on opacity {
            NumberAnimation { duration: settings.ccAnimationDuration }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: controlCenter.hide()
        }
    }

    // Main panel
    Rectangle {
        id: panel

        width: settings.ccWidth
        color: Qt.rgba(settings.colorBackground.r, settings.colorBackground.g, settings.colorBackground.b, 0.95)
        radius: settings.ccPanelRadius
        border.width: settings.ccPanelBorderWidth
        border.color: settings.colorBorder

        // Dynamic height based on content
        height: contentColumn.implicitHeight + (settings.ccPadding * 2)

        // Position based on config
        x: {
            switch(settings.ccPosition) {
                case "top-left": return settings.ccMarginSide
                case "top-center": return (parent.width - width) / 2
                case "top-right":
                default: return parent.width - width - settings.ccMarginSide
            }
        }

        // Animation properties
        y: {
            if (settings.ccAnimation === "slide") {
                return panelVisible ? settings.ccMarginTop : -height - 20
            }
            return settings.ccMarginTop
        }

        opacity: {
            if (settings.ccAnimation === "fade" || settings.ccAnimation === "scale" || settings.ccAnimation === "bounce") {
                return panelVisible ? 1 : 0
            }
            return 1
        }

        scale: {
            if (settings.ccAnimation === "scale") {
                return panelVisible ? 1 : 0.9
            }
            if (settings.ccAnimation === "bounce") {
                return panelVisible ? 1 : 0.8
            }
            return 1
        }

        // Animation behaviors
        Behavior on y {
            enabled: settings.ccAnimation === "slide"
            NumberAnimation {
                duration: settings.ccAnimationDuration
                easing.type: Easing.OutCubic
            }
        }

        Behavior on opacity {
            enabled: settings.ccAnimation === "fade" || settings.ccAnimation === "scale" || settings.ccAnimation === "bounce"
            NumberAnimation {
                duration: settings.ccAnimationDuration
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            enabled: settings.ccAnimation === "scale" || settings.ccAnimation === "bounce"
            NumberAnimation {
                duration: settings.ccAnimation === "bounce" ? settings.ccAnimationDuration * 1.2 : settings.ccAnimationDuration
                easing.type: settings.ccAnimation === "bounce" ? Easing.OutBack : Easing.OutCubic
                easing.overshoot: settings.ccAnimationOvershoot
            }
        }

        // Content
        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: settings.ccPadding
            spacing: settings.ccCardSpacing

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Control Center"
                    font.family: settings.fontFamily
                    font.pixelSize: settings.fontSizeHeader
                    font.bold: true
                    color: settings.colorText
                }

                Item { Layout.fillWidth: true }

                // Settings gear
                Rectangle {
                    width: 28
                    height: 28
                    radius: settings.radiusSmall
                    color: gearMouse.containsMouse ? settings.colorBackgroundAlt : "transparent"

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "󰒓"
                        font.family: settings.fontFamily
                        font.pixelSize: settings.fontSizeIcon
                        color: gearMouse.containsMouse ? settings.colorAccent : settings.colorTextDim

                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    MouseArea {
                        id: gearMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            controlCenter.hide()
                            if (settingsPanel) settingsPanel.show()
                        }
                    }
                }
            }

            // Quick Toggles Grid
            GridLayout {
                Layout.fillWidth: true
                columns: settings.ccToggleColumns
                rowSpacing: settings.ccCardSpacing
                columnSpacing: settings.ccCardSpacing

                QuickToggle {
                    icon: "󰤨"
                    iconOff: "󰤭"
                    label: "WiFi"
                    isOn: true
                }

                QuickToggle {
                    icon: "󰂯"
                    iconOff: "󰂲"
                    label: "Bluetooth"
                    isOn: false
                }

                QuickToggle {
                    icon: "󰍶"
                    iconOff: "󰍷"
                    label: "DND"
                    isOn: false
                    accentColor: settings.colorError
                }

                QuickToggle {
                    icon: "󰖨"
                    iconOff: "󱩌"
                    label: "Night Light"
                    isOn: false
                    accentColor: settings.colorWarning
                }

                QuickToggle {
                    icon: "󰀝"
                    iconOff: "󰀞"
                    label: "Airplane"
                    isOn: false
                    accentColor: settings.colorPurple
                }

                QuickToggle {
                    icon: "󱐋"
                    iconOff: "󱐌"
                    label: "Power Save"
                    isOn: false
                    accentColor: settings.colorTeal
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: settings.colorBorder
            }

            // Volume Slider
            SliderCard {
                Layout.fillWidth: true
                icon: "󰕾"
                iconMuted: "󰖁"
                label: "Volume"
                value: 50
                accentColor: settings.colorAccent
            }

            // Brightness Slider
            SliderCard {
                Layout.fillWidth: true
                icon: "󰃟"
                iconMuted: "󰃞"
                label: "Brightness"
                value: 70
                accentColor: settings.colorWarning
                isMutable: false
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: settings.colorBorder
            }

            // Media Player
            MediaCard {
                Layout.fillWidth: true
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: settings.colorBorder
            }

            // Bottom row - Power & Lock
            RowLayout {
                Layout.fillWidth: true
                spacing: settings.ccCardSpacing

                ActionButton {
                    Layout.fillWidth: true
                    icon: "󰌾"
                    label: "Lock"
                    onClicked: lockProcess.running = true
                }

                ActionButton {
                    Layout.fillWidth: true
                    icon: "󰐥"
                    label: "Power"
                    accentColor: settings.colorError
                    onClicked: powerProcess.running = true
                }
            }
        }
    }

    // Processes
    Process {
        id: lockProcess
        running: false
        command: ["hyprlock"]
        onExited: running = false
    }

    Process {
        id: powerProcess
        running: false
        command: ["wlogout"]
        onExited: running = false
    }

    // ========================================
    // REUSABLE COMPONENTS
    // ========================================

    component QuickToggle: Rectangle {
        id: toggle

        property string icon: "󰛨"
        property string iconOff: icon
        property string label: "Toggle"
        property bool isOn: false
        property color accentColor: settings.colorSuccess

        Layout.fillWidth: true
        height: settings.ccToggleHeight
        radius: settings.ccCardRadius
        color: isOn ? Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.2) : settings.colorBackgroundAlt
        border.width: isOn ? 2 : 0
        border.color: accentColor

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.width { NumberAnimation { duration: 150 } }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 4

            Text {
                text: isOn ? icon : iconOff
                font.family: settings.fontFamily
                font.pixelSize: settings.ccToggleIconSize
                color: isOn ? accentColor : settings.colorTextDim
                Layout.alignment: Qt.AlignHCenter

                Behavior on color { ColorAnimation { duration: 150 } }
            }

            Text {
                text: label
                font.family: settings.fontFamily
                font.pixelSize: settings.fontSizeLabel - 2
                color: isOn ? settings.colorText : settings.colorTextMuted
                Layout.alignment: Qt.AlignHCenter

                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: toggle.isOn = !toggle.isOn
        }
    }

    component SliderCard: Rectangle {
        id: sliderCard

        property string icon: "󰕾"
        property string iconMuted: "󰖁"
        property string label: "Slider"
        property int value: 50
        property color accentColor: settings.colorAccent
        property bool isMuted: false
        property bool isMutable: true

        height: settings.ccSliderHeight + 36
        radius: settings.ccCardRadius
        color: settings.colorBackgroundAlt

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: isMuted ? iconMuted : icon
                    font.family: settings.fontFamily
                    font.pixelSize: settings.fontSizeIcon
                    color: isMuted ? settings.colorTextMuted : accentColor

                    MouseArea {
                        anchors.fill: parent
                        visible: isMutable
                        cursorShape: Qt.PointingHandCursor
                        onClicked: sliderCard.isMuted = !sliderCard.isMuted
                    }
                }

                Text {
                    text: label
                    font.family: settings.fontFamily
                    font.pixelSize: settings.fontSizeLabel
                    color: settings.colorText
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: value + "%"
                    font.family: settings.fontFamily
                    font.pixelSize: settings.fontSizeLabel
                    font.bold: true
                    color: settings.colorTextDim
                }
            }

            Item {
                Layout.fillWidth: true
                height: settings.ccSliderHeight

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 8
                    radius: 4
                    color: settings.colorSurface

                    Rectangle {
                        width: (sliderCard.value / 100) * parent.width
                        height: parent.height
                        radius: parent.radius
                        color: sliderCard.isMuted ? settings.colorTextMuted : accentColor

                        Behavior on width { NumberAnimation { duration: 50 } }
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }

                Rectangle {
                    x: (sliderCard.value / 100) * (parent.width - width)
                    anchors.verticalCenter: parent.verticalCenter
                    width: settings.ccSliderHandleSize
                    height: settings.ccSliderHandleSize
                    radius: settings.ccSliderHandleSize / 2
                    color: sliderCard.isMuted ? settings.colorTextMuted : accentColor

                    Behavior on x { NumberAnimation { duration: 50 } }
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onPositionChanged: (mouse) => {
                        if (pressed) {
                            var newVal = Math.max(0, Math.min(100, (mouse.x / width) * 100))
                            sliderCard.value = Math.round(newVal)
                        }
                    }

                    onClicked: (mouse) => {
                        var newVal = Math.max(0, Math.min(100, (mouse.x / width) * 100))
                        sliderCard.value = Math.round(newVal)
                    }
                }
            }
        }
    }

    component MediaCard: Rectangle {
        id: mediaCard

        property string title: "No media playing"
        property string artist: ""
        property bool isPlaying: false

        height: 80
        radius: settings.ccCardRadius
        color: settings.colorBackgroundAlt

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            Rectangle {
                width: 56
                height: 56
                radius: settings.radiusSmall
                color: settings.colorSurface

                Text {
                    anchors.centerIn: parent
                    text: "󰝚"
                    font.family: settings.fontFamily
                    font.pixelSize: 24
                    color: settings.colorTextMuted
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: title
                    font.family: settings.fontFamily
                    font.pixelSize: settings.fontSizeLabel
                    font.bold: true
                    color: settings.colorText
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    text: artist || "Unknown artist"
                    font.family: settings.fontFamily
                    font.pixelSize: settings.fontSizeLabel - 2
                    color: settings.colorTextDim
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                spacing: 4

                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: prevMouse.containsMouse ? settings.colorSurface : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "󰒮"
                        font.family: settings.fontFamily
                        font.pixelSize: 16
                        color: settings.colorText
                    }

                    MouseArea {
                        id: prevMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: mediaPrev.running = true
                    }
                }

                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: settings.colorAccent

                    Text {
                        anchors.centerIn: parent
                        text: isPlaying ? "󰏤" : "󰐊"
                        font.family: settings.fontFamily
                        font.pixelSize: 18
                        color: settings.colorBackground
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            mediaCard.isPlaying = !mediaCard.isPlaying
                            mediaToggle.running = true
                        }
                    }
                }

                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: nextMouse.containsMouse ? settings.colorSurface : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "󰒭"
                        font.family: settings.fontFamily
                        font.pixelSize: 16
                        color: settings.colorText
                    }

                    MouseArea {
                        id: nextMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: mediaNext.running = true
                    }
                }
            }
        }
    }

    component ActionButton: Rectangle {
        id: actionBtn

        property string icon: "󰐥"
        property string label: "Action"
        property color accentColor: settings.colorAccent

        signal clicked()

        Layout.fillWidth: true
        height: 44
        radius: settings.ccCardRadius
        color: btnMouse.containsMouse ? Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.2) : settings.colorBackgroundAlt
        border.width: btnMouse.containsMouse ? 2 : 0
        border.color: accentColor

        Behavior on color { ColorAnimation { duration: 150 } }

        RowLayout {
            anchors.centerIn: parent
            spacing: 8

            Text {
                text: icon
                font.family: settings.fontFamily
                font.pixelSize: settings.fontSizeIcon
                color: accentColor
            }

            Text {
                text: label
                font.family: settings.fontFamily
                font.pixelSize: settings.fontSizeLabel
                color: settings.colorText
            }
        }

        MouseArea {
            id: btnMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: actionBtn.clicked()
        }
    }

    // Media control processes
    Process {
        id: mediaToggle
        running: false
        command: ["playerctl", "play-pause"]
        onExited: running = false
    }

    Process {
        id: mediaPrev
        running: false
        command: ["playerctl", "previous"]
        onExited: running = false
    }

    Process {
        id: mediaNext
        running: false
        command: ["playerctl", "next"]
        onExited: running = false
    }
}

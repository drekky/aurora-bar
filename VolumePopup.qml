import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

WlrLayershell {
    id: volumePopup

    property var settings: null
    property int currentVolume: 50
    property bool volumeMuted: false

    signal volumeChanged(int vol)
    signal muteToggled()

    property bool popupVisible: false

    function show() {
        popupVisible = true
    }

    function hide() {
        popupVisible = false
    }

    function toggle() {
        popupVisible = !popupVisible
    }

    layer: WlrLayer.Overlay
    exclusiveZone: 0
    namespace: "volume-popup"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"
    visible: popupVisible

    // Click outside to close (full screen transparent area)
    MouseArea {
        anchors.fill: parent
        onClicked: volumePopup.hide()
    }

    // Popup panel
    Rectangle {
        width: 280
        height: 80
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 60
        anchors.rightMargin: 200

        color: settings ? Qt.rgba(settings.colorBackground.r, settings.colorBackground.g, settings.colorBackground.b, 0.95) : Qt.rgba(0.118, 0.118, 0.18, 0.95)
        radius: settings ? settings.radiusSmall : 8
        border.width: 1
        border.color: settings ? settings.colorBorder : "#45475a"

        // Prevent clicks on popup from closing it
        MouseArea {
            anchors.fill: parent
            onClicked: {} // absorb click
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: volumePopup.volumeMuted ? "󰖁" : "󰕾"
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeIcon : 16
                    color: volumePopup.volumeMuted ? (settings ? settings.colorTextMuted : "#6c7086") : (settings ? settings.colorAccent : "#89b4fa")

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: volumePopup.muteToggled()
                    }
                }

                Text {
                    text: "Volume"
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeLabel : 12
                    color: settings ? settings.colorText : "#cdd6f4"
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: volumePopup.currentVolume + "%"
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeLabel : 12
                    font.bold: true
                    color: settings ? settings.colorTextDim : "#a6adc8"
                }
            }

            Item {
                Layout.fillWidth: true
                height: 20

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 8
                    radius: 4
                    color: settings ? settings.colorSurface : "#313244"

                    Rectangle {
                        width: (volumePopup.currentVolume / 100) * parent.width
                        height: parent.height
                        radius: parent.radius
                        color: volumePopup.volumeMuted ? (settings ? settings.colorTextMuted : "#6c7086") : (settings ? settings.colorAccent : "#89b4fa")
                        Behavior on width { NumberAnimation { duration: 50 } }
                    }
                }

                Rectangle {
                    x: (volumePopup.currentVolume / 100) * (parent.width - width)
                    anchors.verticalCenter: parent.verticalCenter
                    width: 16
                    height: 16
                    radius: 8
                    color: volumePopup.volumeMuted ? (settings ? settings.colorTextMuted : "#6c7086") : (settings ? settings.colorAccent : "#89b4fa")
                    Behavior on x { NumberAnimation { duration: 50 } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onPositionChanged: (mouse) => {
                        if (pressed) {
                            var newVal = Math.max(0, Math.min(100, (mouse.x / width) * 100))
                            volumePopup.volumeChanged(Math.round(newVal))
                        }
                    }
                    onClicked: (mouse) => {
                        var newVal = Math.max(0, Math.min(100, (mouse.x / width) * 100))
                        volumePopup.volumeChanged(Math.round(newVal))
                    }
                }
            }
        }
    }
}

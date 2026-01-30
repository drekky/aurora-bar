import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

WlrLayershell {
    id: wifiPopup

    property var settings: null
    property string wifiNetwork: ""
    property bool wifiConnected: false
    property var wifiNetworks: []

    signal refreshClicked()
    signal networkSelected(string ssid)

    property bool popupVisible: false

    function show() {
        popupVisible = true
        refreshClicked()
    }

    function hide() {
        popupVisible = false
    }

    function toggle() {
        if (!popupVisible) {
            show()
        } else {
            hide()
        }
    }

    layer: WlrLayer.Overlay
    exclusiveZone: 0
    namespace: "wifi-popup"
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
        onClicked: wifiPopup.hide()
    }

    // Popup panel
    Rectangle {
        id: popupPanel
        width: 300
        height: Math.min(350, wifiContent.implicitHeight + 24)
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 60
        anchors.rightMargin: 150

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
            id: wifiContent
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "󰤨"
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeIcon : 16
                    color: settings ? settings.colorSuccess : "#a6e3a1"
                }

                Text {
                    text: "WiFi Networks"
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeLabel : 12
                    font.bold: true
                    color: settings ? settings.colorText : "#cdd6f4"
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 24
                    height: 24
                    radius: 4
                    color: refreshMouse.containsMouse ? (settings ? settings.colorBackgroundAlt : "#313244") : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "󰑓"
                        font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        color: settings ? settings.colorTextDim : "#a6adc8"
                    }

                    MouseArea {
                        id: refreshMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: wifiPopup.refreshClicked()
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 40
                radius: settings ? settings.radiusSmall : 6
                color: settings ? Qt.rgba(settings.colorSuccess.r, settings.colorSuccess.g, settings.colorSuccess.b, 0.15) : Qt.rgba(0.651, 0.890, 0.631, 0.15)
                border.width: 1
                border.color: settings ? Qt.rgba(settings.colorSuccess.r, settings.colorSuccess.g, settings.colorSuccess.b, 0.3) : Qt.rgba(0.651, 0.890, 0.631, 0.3)
                visible: wifiPopup.wifiConnected

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Text {
                        text: "󰤨"
                        font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        color: settings ? settings.colorSuccess : "#a6e3a1"
                    }

                    Text {
                        text: wifiPopup.wifiNetwork || "Connected"
                        font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                        font.pixelSize: settings ? settings.fontSizeLabel : 12
                        color: settings ? settings.colorText : "#cdd6f4"
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "Connected"
                        font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                        font.pixelSize: settings ? settings.fontSizeLabel - 2 : 10
                        color: settings ? settings.colorSuccess : "#a6e3a1"
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: settings ? settings.colorBorder : "#45475a"
                visible: wifiPopup.wifiConnected
            }

            Text {
                text: "Available Networks"
                font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                font.pixelSize: settings ? settings.fontSizeLabel - 1 : 11
                color: settings ? settings.colorTextDim : "#a6adc8"
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: Math.min(180, count * 36)
                clip: true
                spacing: 4
                model: wifiPopup.wifiNetworks

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 34
                    radius: settings ? settings.radiusSmall : 6
                    color: networkMouse.containsMouse ? (settings ? settings.colorBackgroundAlt : "#313244") : "transparent"

                    Behavior on color { ColorAnimation { duration: 100 } }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8

                        Text {
                            text: {
                                var sig = modelData.signal
                                if (sig >= 80) return "󰤨"
                                if (sig >= 60) return "󰤥"
                                if (sig >= 40) return "󰤢"
                                if (sig >= 20) return "󰤟"
                                return "󰤯"
                            }
                            font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
                            color: modelData.active ? (settings ? settings.colorSuccess : "#a6e3a1") : (settings ? settings.colorTextDim : "#a6adc8")
                        }

                        Text {
                            text: modelData.ssid
                            font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                            font.pixelSize: settings ? settings.fontSizeLabel : 12
                            color: settings ? settings.colorText : "#cdd6f4"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: modelData.security ? "󰌾" : ""
                            font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            color: settings ? settings.colorTextMuted : "#6c7086"
                            visible: modelData.security !== ""
                        }

                        Text {
                            text: modelData.signal + "%"
                            font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                            font.pixelSize: settings ? settings.fontSizeLabel - 2 : 10
                            color: settings ? settings.colorTextDim : "#a6adc8"
                        }
                    }

                    MouseArea {
                        id: networkMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (!modelData.active) {
                                wifiPopup.networkSelected(modelData.ssid)
                            }
                        }
                    }
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

WlrLayershell {
    id: quickSettings
    
    layer: WlrLayer.Overlay
    anchors {
        top: true
        right: true
        bottom: true
    }
    
    width: root.panelWidth
    color: "transparent"
    visible: panelVisible
    
    property bool panelVisible: false
    
    margins {
        top: 60
        right: 12
        bottom: 12
    }
    
    // Click outside to close
    MouseArea {
        anchors.fill: parent
        onClicked: panelVisible = false
    }
    
    Rectangle {
        id: panel
        anchors.fill: parent
        color: Qt.rgba(0.118, 0.118, 0.18, 0.95)
        radius: root.cornerRadius
        border.width: 2
        border.color: Qt.rgba(0.537, 0.706, 0.98, 0.3)
        
        // Slide-in animation
        x: panelVisible ? 0 : root.panelWidth
        
        Behavior on x {
            NumberAnimation {
                duration: root.animationDuration
                easing.type: Easing.OutCubic
            }
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: root.padding
            spacing: root.spacing
            
            // Header
            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    text: "Quick Settings"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                    font.bold: true
                    color: root.blue
                    Layout.fillWidth: true
                }
                
                Rectangle {
                    width: 32
                    height: 32
                    radius: 8
                    color: Qt.rgba(0.957, 0.545, 0.659, 0.2)
                    
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 16
                        color: root.red
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: panelVisible = false
                    }
                }
            }
            
            // System info cards
            Rectangle {
                Layout.fillWidth: true
                height: 80
                color: Qt.rgba(0.196, 0.196, 0.266, 0.6)
                radius: 10
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12
                    
                    // CPU
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        Text {
                            text: "CPU"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: root.subtext0
                        }
                        
                        Text {
                            text: "45%"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 20
                            font.bold: true
                            color: root.blue
                        }
                    }
                    
                    Rectangle {
                        width: 1
                        Layout.fillHeight: true
                        color: root.surface1
                    }
                    
                    // RAM
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        Text {
                            text: "RAM"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: root.subtext0
                        }
                        
                        Text {
                            text: "8.2 GB"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 20
                            font.bold: true
                            color: root.green
                        }
                    }
                    
                    Rectangle {
                        width: 1
                        Layout.fillHeight: true
                        color: root.surface1
                    }
                    
                    // Temp
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        Text {
                            text: "TEMP"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: root.subtext0
                        }
                        
                        Text {
                            text: "52°C"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 20
                            font.bold: true
                            color: root.yellow
                        }
                    }
                }
            }
            
            // Quick toggles
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 12
                rowSpacing: 12
                
                QuickToggle {
                    iconText: "󰖩"
                    label: "Wi-Fi"
                    isActive: true
                    activeColor: root.green
                    command: "nmcli radio wifi"
                }
                
                QuickToggle {
                    iconText: "󰂯"
                    label: "Bluetooth"
                    isActive: false
                    activeColor: root.blue
                    command: "bluetoothctl"
                }
                
                QuickToggle {
                    iconText: "󰍹"
                    label: "Do Not Disturb"
                    isActive: false
                    activeColor: root.red
                    command: "notify-send 'DND toggled'"
                }
                
                QuickToggle {
                    iconText: "󰌵"
                    label: "Night Light"
                    isActive: true
                    activeColor: root.peach
                    command: "gammastep"
                }
            }
            
            // Volume slider
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                
                RowLayout {
                    Layout.fillWidth: true
                    
                    Text {
                        text: "󰕾"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                        color: root.blue
                    }
                    
                    Text {
                        text: "Volume"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        color: root.text
                        Layout.fillWidth: true
                    }
                    
                    Text {
                        text: volumeSlider.value + "%"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        font.bold: true
                        color: root.blue
                    }
                }
                
                Slider {
                    id: volumeSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: 65
                    
                    background: Rectangle {
                        width: volumeSlider.availableWidth
                        height: 6
                        radius: 3
                        color: root.surface1
                        
                        Rectangle {
                            width: volumeSlider.visualPosition * parent.width
                            height: parent.height
                            radius: parent.radius
                            color: root.blue
                            
                            Behavior on width {
                                NumberAnimation { duration: 100 }
                            }
                        }
                    }
                    
                    handle: Rectangle {
                        x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        width: 20
                        height: 20
                        radius: 10
                        color: root.blue
                        border.width: 2
                        border.color: root.base
                    }
                }
            }
            
            // Brightness slider
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                
                RowLayout {
                    Layout.fillWidth: true
                    
                    Text {
                        text: "󰃠"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                        color: root.yellow
                    }
                    
                    Text {
                        text: "Brightness"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        color: root.text
                        Layout.fillWidth: true
                    }
                    
                    Text {
                        text: brightnessSlider.value + "%"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        font.bold: true
                        color: root.yellow
                    }
                }
                
                Slider {
                    id: brightnessSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: 80
                    
                    background: Rectangle {
                        width: brightnessSlider.availableWidth
                        height: 6
                        radius: 3
                        color: root.surface1
                        
                        Rectangle {
                            width: brightnessSlider.visualPosition * parent.width
                            height: parent.height
                            radius: parent.radius
                            color: root.yellow
                            
                            Behavior on width {
                                NumberAnimation { duration: 100 }
                            }
                        }
                    }
                    
                    handle: Rectangle {
                        x: brightnessSlider.leftPadding + brightnessSlider.visualPosition * (brightnessSlider.availableWidth - width)
                        y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                        width: 20
                        height: 20
                        radius: 10
                        color: root.yellow
                        border.width: 2
                        border.color: root.base
                    }
                }
            }
            
            Item { Layout.fillHeight: true }
            
            // Power options
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                PowerButton {
                    iconText: "󰤄"
                    label: "Sleep"
                    color: root.blue
                    command: "systemctl suspend"
                }
                
                PowerButton {
                    iconText: "󰜉"
                    label: "Restart"
                    color: root.yellow
                    command: "systemctl reboot"
                }
                
                PowerButton {
                    iconText: "󰐥"
                    label: "Shutdown"
                    color: root.red
                    command: "systemctl poweroff"
                }
            }
        }
    }
}

// Quick Toggle Component
Rectangle {
    id: quickToggle
    
    property string iconText: ""
    property string label: ""
    property bool isActive: false
    property color activeColor: root.blue
    property string command: ""
    
    Layout.fillWidth: true
    height: 70
    radius: 10
    color: isActive ? Qt.rgba(activeColor.r, activeColor.g, activeColor.b, 0.2) : 
                      Qt.rgba(0.196, 0.196, 0.266, 0.6)
    border.width: 2
    border.color: isActive ? activeColor : "transparent"
    
    Behavior on color {
        ColorAnimation { duration: root.fastAnimation }
    }
    
    Behavior on border.color {
        ColorAnimation { duration: root.fastAnimation }
    }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 6
        
        Text {
            text: iconText
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 24
            color: isActive ? activeColor : root.text
            Layout.alignment: Qt.AlignCenter
            
            Behavior on color {
                ColorAnimation { duration: root.fastAnimation }
            }
        }
        
        Text {
            text: label
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 11
            color: root.subtext0
            Layout.alignment: Qt.AlignCenter
        }
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            isActive = !isActive
            Qt.execute(command)
        }
    }
}

// Power Button Component
Rectangle {
    id: powerButton
    
    property string iconText: ""
    property string label: ""
    property color color: root.blue
    property string command: ""
    
    Layout.fillWidth: true
    height: 60
    radius: 10
    color: Qt.rgba(this.color.r, this.color.g, this.color.b, 0.2)
    border.width: 2
    border.color: this.color
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 4
        
        Text {
            text: iconText
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 20
            color: powerButton.color
            Layout.alignment: Qt.AlignCenter
        }
        
        Text {
            text: label
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 10
            color: root.text
            Layout.alignment: Qt.AlignCenter
        }
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            Qt.execute(command)
        }
    }
}

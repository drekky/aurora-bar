import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

WlrLayershell {
    id: bar

    property var settings: null
    property var launcherComponent: null
    property var controlCenterComponent: null
    property var volumePopupComponent: null
    property var wifiPopupComponent: null
    property bool powerMenuOpen: false
    property var powerMenuItems: [
        { label: "Lock", command: ["loginctl", "lock-session"] },
        { label: "Logout", command: ["hyprctl", "dispatch", "exit"] },
        { label: "Suspend", command: ["systemctl", "suspend"] },
        { label: "Hibernate", command: ["systemctl", "hibernate"] },
        { label: "Restart", command: ["systemctl", "reboot"] },
        { label: "Power Off", command: ["systemctl", "poweroff"] }
    ]

    // System state properties
    property int currentVolume: 50
    property bool volumeMuted: false
    property int batteryPercent: 0
    property bool batteryCharging: false
    property string batteryStatus: "Unknown"
    property string wifiNetwork: ""
    property bool wifiConnected: false
    property var wifiNetworks: []


    layer: WlrLayer.Top
    anchors {
        top: true
        left: true
        right: true
    }
    margins {
        top: settings ? settings.barMarginTop : 8
        left: settings ? settings.barMarginSide : 12
        right: settings ? settings.barMarginSide : 12
    }

    implicitHeight: settings ? settings.barHeight : 43
    color: "transparent"

    // ========================================
    // SYSTEM MONITORING PROCESSES
    // ========================================

    // Volume monitoring - using sh -c for reliable output capture
    Process {
        id: volumeGet
        running: false
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || echo 'Volume: 0.50'"]
        stdout: SplitParser {
            onRead: data => {
                // Output format: "Volume: 0.50" or "Volume: 0.50 [MUTED]"
                var match = data.match(/Volume:\s*([\d.]+)/)
                if (match) {
                    bar.currentVolume = Math.round(parseFloat(match[1]) * 100)
                }
                bar.volumeMuted = data.includes("[MUTED]")
            }
        }
        onExited: running = false
    }

    Timer {
        id: volumeTimer
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            volumeGet.running = true
        }
    }

    // Volume control processes
    function setVolume(vol) {
        var v = Math.max(0, Math.min(100, vol))
        currentVolume = v
        volumeSetProcess.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (v / 100).toFixed(2)]
        volumeSetProcess.running = true
    }

    function toggleMute() {
        volumeMuteProcess.running = true
    }

    Process {
        id: volumeSetProcess
        running: false
        onExited: running = false
    }

    Process {
        id: volumeMuteProcess
        running: false
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        onExited: {
            running = false
            volumeGet.running = true
        }
    }

    // Battery monitoring - combined command for reliability
    Process {
        id: batteryGet
        running: false
        command: ["sh", "-c", "echo \"$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0)|$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo Unknown)\""]
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split('|')
                if (parts.length >= 2) {
                    var val = parseInt(parts[0])
                    if (!isNaN(val)) {
                        bar.batteryPercent = val
                    }
                    var status = parts[1].trim()
                    bar.batteryStatus = status
                    bar.batteryCharging = (status === "Charging" || status === "Full")
                }
            }
        }
        onExited: running = false
    }

    Timer {
        id: batteryTimer
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            batteryGet.running = true
        }
    }

    // WiFi monitoring - get SSID from active device
    property string _wifiCheckResult: ""

    Process {
        id: wifiGet
        running: false
        command: ["sh", "-c", "nmcli -t -f active,ssid dev wifi list 2>/dev/null | grep '^yes:' | cut -d: -f2 | head -1 || echo ''"]
        stdout: SplitParser {
            onRead: data => {
                bar._wifiCheckResult = data.trim()
            }
        }
        onExited: {
            running = false
            if (bar._wifiCheckResult && bar._wifiCheckResult !== "") {
                bar.wifiNetwork = bar._wifiCheckResult
                bar.wifiConnected = true
            } else {
                bar.wifiNetwork = ""
                bar.wifiConnected = false
            }
            bar._wifiCheckResult = ""
        }
    }

    Timer {
        id: wifiTimer
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            wifiGet.running = true
        }
    }

    // WiFi network scan
    Process {
        id: wifiScan
        running: false
        command: ["sh", "-c", "nmcli -t -f SSID,SIGNAL,SECURITY,ACTIVE dev wifi list 2>/dev/null || echo ''"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var lines = data.trim().split('\n')
                var networks = []
                var seen = {}
                for (var i = 0; i < lines.length; i++) {
                    var parts = lines[i].split(':')
                    if (parts[0] && parts[0] !== "" && !seen[parts[0]]) {
                        seen[parts[0]] = true
                        networks.push({
                            ssid: parts[0],
                            signal: parseInt(parts[1]) || 0,
                            security: parts[2] || "",
                            active: parts[3] === "yes"
                        })
                    }
                }
                networks.sort((a, b) => b.signal - a.signal)
                bar.wifiNetworks = networks
            }
        }
        onExited: running = false
    }

    function scanWifi() {
        wifiScan.running = true
    }

    function connectWifi(ssid) {
        wifiConnectProcess.command = ["nmcli", "dev", "wifi", "connect", ssid]
        wifiConnectProcess.running = true
    }

    Process {
        id: wifiConnectProcess
        running: false
        onExited: {
            running = false
            wifiGet.running = true
        }
    }

    // Power actions
    Process {
        id: powerAction
        running: false
        onExited: running = false
    }

    function runPowerAction(cmd) {
        powerAction.command = cmd
        powerAction.running = true
    }

    // Screenshot functions
    function takeScreenshotRegion() {
        screenshotRegion.running = true
    }

    function takeScreenshotFull() {
        screenshotFull.running = true
    }

    Process {
        id: screenshotRegion
        running: false
        command: ["sh", "-c", "grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Copied to clipboard'"]
        onExited: running = false
    }

    Process {
        id: screenshotFull
        running: false
        command: ["sh", "-c", "mkdir -p /home/drek/Pictures/Screenshots && grim /home/drek/Pictures/Screenshots/$(date +%F_%H-%M-%S).png && notify-send 'Screenshot' 'Saved to ~/Pictures/Screenshots'"]
        onExited: running = false
    }

    Process {
        id: workspaceSwitch
        running: false
        onExited: running = false
    }

    // Close popups when clicking elsewhere
    function closeAllPopups() {
        if (volumePopupComponent) volumePopupComponent.hide()
        if (wifiPopupComponent) wifiPopupComponent.hide()
        powerMenuOpen = false
    }

    Rectangle {
        id: barBackground
        anchors.fill: parent
        color: settings ? Qt.rgba(settings.colorBackground.r, settings.colorBackground.g, settings.colorBackground.b, settings.barOpacity) : Qt.rgba(0.118, 0.118, 0.18, 0.85)
        radius: settings ? settings.barRadius : 12
        border.width: settings ? settings.barBorderWidth : 2
        border.color: settings ? settings.colorBorder : Qt.rgba(0.537, 0.706, 0.98, 0.2)

        NumberAnimation on opacity {
            from: 0
            to: 1
            duration: 300
            easing.type: Easing.OutCubic
            running: true
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 6
            spacing: 12

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                spacing: 8

                Repeater {
                    model: settings ? settings.barWidgetsLeft : ["launcher", "workspaces"]
                    delegate: Loader { sourceComponent: widgetComponent(modelData) }
                }
            }

            Item {
                Layout.fillWidth: true

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    Repeater {
                        model: settings ? settings.barWidgetsCenter : ["clock"]
                        delegate: Loader { sourceComponent: widgetComponent(modelData) }
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 8

                Repeater {
                    model: settings ? settings.barWidgetsRight : ["volume", "wifi", "battery", "screenshot", "controlCenter", "power"]
                    delegate: Loader { sourceComponent: widgetComponent(modelData) }
                }
            }
        }
    }

    WlrLayershell {
        id: powerMenuLayer
        visible: powerMenuOpen
        layer: WlrLayer.Top
        exclusiveZone: 0
        color: "transparent"
        anchors {
            top: true
            right: true
        }
        margins {
            top: (settings ? settings.barMarginTop : 8) + (settings ? settings.barHeight : 43) + 8
            right: settings ? settings.barMarginSide : 12
        }
        width: 200
        height: powerMenuColumn.implicitHeight + 16

        Rectangle {
            anchors.fill: parent
            radius: settings ? settings.radiusMedium : 12
            color: settings ? settings.colorBackgroundAlt : Qt.rgba(0.118, 0.118, 0.18, 0.95)
            border.width: settings ? settings.borderWidth : 2
            border.color: settings ? settings.colorBorder : Qt.rgba(0.537, 0.706, 0.98, 0.3)

            ColumnLayout {
                id: powerMenuColumn
                anchors.fill: parent
                anchors.margins: 8
                spacing: 6

                Repeater {
                    model: powerMenuItems
                    delegate: Rectangle {
                        height: 34
                        radius: settings ? settings.radiusSmall : 8
                        color: itemMouse.containsMouse ? (settings ? Qt.rgba(settings.colorAccent.r, settings.colorAccent.g, settings.colorAccent.b, 0.2) : Qt.rgba(0.537, 0.706, 0.98, 0.2)) : "transparent"
                        Layout.fillWidth: true

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            text: modelData.label
                            font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                            font.pixelSize: settings ? settings.fontSizeLabel : 12
                            color: settings ? settings.colorText : "#cdd6f4"
                        }

                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                powerMenuOpen = false
                                runPowerAction(modelData.command)
                            }
                        }
                    }
                }
            }
        }
    }

    function widgetComponent(widgetId) {
        switch (widgetId) {
            case "launcher": return launcherWidget
            case "workspaces": return workspacesWidget
            case "clock": return clockWidget
            case "systemTray": return systemTrayWidget
            case "volume": return volumeWidget
            case "wifi": return wifiWidget
            case "battery": return batteryWidget
            case "screenshot": return screenshotWidget
            case "controlCenter": return controlCenterWidget
            case "power": return powerWidget
            default: return null
        }
    }

    function clockTimeFormat() {
        if (!settings) return "hh:mm"
        if (settings.clockTimeFormat && settings.clockTimeFormat !== "") return settings.clockTimeFormat
        return settings.clockUse24h ? "HH:mm" : "hh:mm ap"
    }

    function clockDateFormat() {
        if (!settings) return "yyyy-MM-dd"
        if (settings.clockDateFormat && settings.clockDateFormat !== "") return settings.clockDateFormat
        return "yyyy-MM-dd"
    }

    Component {
        id: launcherWidget

        Rectangle {
            width: 40
            height: 32
            color: settings ? settings.colorAccent : "#89b4fa"
            radius: settings ? settings.radiusSmall : 8

            Text {
                anchors.centerIn: parent
                text: "󰣇"
                font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                font.pixelSize: settings ? settings.fontSizeIcon + 2 : 20
                color: settings ? settings.colorBackground : "#1e1e2e"
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (launcherComponent) {
                        launcherComponent.toggle()
                    }
                }
            }
        }
    }

    Component {
        id: workspacesWidget

        Rectangle {
            height: 32
            width: workspaceRow.width + 16
            color: "transparent"

            RowLayout {
                id: workspaceRow
                anchors.centerIn: parent
                spacing: 4

                Repeater {
                    model: settings ? settings.workspaceCount : 5

                        Rectangle {
                            width: 32
                            height: 28
                            radius: settings ? settings.radiusSmall : 6
                        color: settings ? settings.colorBackgroundAlt : Qt.rgba(0.118, 0.118, 0.18, 0.6)
                        border.width: 1
                        border.color: settings ? settings.colorBorder : "#45475a"

                            Text {
                                anchors.centerIn: parent
                                text: index + 1
                                font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                                font.pixelSize: settings ? settings.fontSizeLabel : 12
                                color: settings ? settings.colorText : "#cdd6f4"
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    workspaceSwitch.command = ["hyprctl", "dispatch", "workspace", String(index + 1)]
                                    workspaceSwitch.startDetached()
                                }
                            }
                        }
                    }
                }
            }
    }

    Component {
        id: clockWidget

        Rectangle {
            height: 32
            width: clockRow.implicitWidth + 24
            color: settings ? Qt.rgba(settings.colorAccent.r, settings.colorAccent.g, settings.colorAccent.b, 0.15) : Qt.rgba(0.537, 0.706, 0.98, 0.15)
            radius: settings ? settings.radiusSmall : 8
            border.width: settings ? settings.borderWidth : 2
            border.color: settings ? Qt.rgba(settings.colorAccent.r, settings.colorAccent.g, settings.colorAccent.b, 0.3) : Qt.rgba(0.537, 0.706, 0.98, 0.3)

            RowLayout {
                id: clockRow
                anchors.centerIn: parent
                spacing: 12

                Text {
                    id: timeText
                    text: Qt.formatTime(new Date(), bar.clockTimeFormat())
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeHeader : 15
                    font.bold: true
                    color: settings ? settings.colorAccent : "#89b4fa"
                }

                Text {
                    id: dateText
                    visible: settings ? settings.clockShowDate : false
                    text: Qt.formatDate(new Date(), bar.clockDateFormat())
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeLabel : 12
                    color: settings ? settings.colorTextDim : "#a6adc8"
                }
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    timeText.text = Qt.formatTime(new Date(), bar.clockTimeFormat())
                    dateText.text = Qt.formatDate(new Date(), bar.clockDateFormat())
                }
            }
        }
    }

    // Legacy systemTrayWidget kept for backward compatibility
    Component {
        id: systemTrayWidget

        RowLayout {
            spacing: 4
            Loader { sourceComponent: volumeWidget }
            Loader { sourceComponent: wifiWidget }
            Loader { sourceComponent: batteryWidget }
        }
    }

    // ========================================
    // VOLUME WIDGET
    // ========================================
    Component {
        id: volumeWidget

        Rectangle {
            id: volumeBtn
            width: volumeRow.implicitWidth + 16
            height: 30
            property bool popupOpen: volumePopupComponent ? volumePopupComponent.popupVisible : false
            color: volumeMouse.containsMouse || popupOpen ? (settings ? Qt.rgba(settings.colorAccent.r, settings.colorAccent.g, settings.colorAccent.b, 0.2) : Qt.rgba(0.537, 0.706, 0.98, 0.2)) : (settings ? settings.colorBackgroundAlt : Qt.rgba(0.118, 0.118, 0.18, 0.6))
            radius: settings ? settings.radiusSmall : 8
            border.width: volumeMouse.containsMouse || popupOpen ? 1 : 0
            border.color: settings ? Qt.rgba(settings.colorAccent.r, settings.colorAccent.g, settings.colorAccent.b, 0.4) : Qt.rgba(0.537, 0.706, 0.98, 0.4)

            Behavior on color { ColorAnimation { duration: 150 } }

            RowLayout {
                id: volumeRow
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: bar.volumeMuted ? "󰖁" : (bar.currentVolume > 50 ? "󰕾" : (bar.currentVolume > 0 ? "󰖀" : "󰕿"))
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeIcon : 14
                    color: bar.volumeMuted ? (settings ? settings.colorTextMuted : "#6c7086") : (settings ? settings.colorAccent : "#89b4fa")
                }

                Text {
                    text: bar.currentVolume + "%"
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeLabel - 2 : 11
                    color: settings ? settings.colorText : "#cdd6f4"
                }
            }

            MouseArea {
                id: volumeMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (mouse) => {
                    if (mouse.button === Qt.RightButton) {
                        bar.toggleMute()
                    } else {
                        if (wifiPopupComponent) wifiPopupComponent.hide()
                        if (volumePopupComponent) volumePopupComponent.toggle()
                    }
                }
            }
        }
    }

    // ========================================
    // WIFI WIDGET
    // ========================================
    Component {
        id: wifiWidget

        Rectangle {
            id: wifiBtn
            width: wifiRow.implicitWidth + 16
            height: 30
            property bool popupOpen: wifiPopupComponent ? wifiPopupComponent.popupVisible : false
            color: wifiMouse.containsMouse || popupOpen ? (settings ? Qt.rgba(settings.colorSuccess.r, settings.colorSuccess.g, settings.colorSuccess.b, 0.2) : Qt.rgba(0.651, 0.890, 0.631, 0.2)) : (settings ? settings.colorBackgroundAlt : Qt.rgba(0.118, 0.118, 0.18, 0.6))
            radius: settings ? settings.radiusSmall : 8
            border.width: wifiMouse.containsMouse || popupOpen ? 1 : 0
            border.color: settings ? Qt.rgba(settings.colorSuccess.r, settings.colorSuccess.g, settings.colorSuccess.b, 0.4) : Qt.rgba(0.651, 0.890, 0.631, 0.4)

            Behavior on color { ColorAnimation { duration: 150 } }

            RowLayout {
                id: wifiRow
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: bar.wifiConnected ? "󰤨" : "󰤭"
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeIcon : 14
                    color: bar.wifiConnected ? (settings ? settings.colorSuccess : "#a6e3a1") : (settings ? settings.colorTextMuted : "#6c7086")
                }
            }

            MouseArea {
                id: wifiMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (volumePopupComponent) volumePopupComponent.hide()
                    if (wifiPopupComponent) wifiPopupComponent.toggle()
                }
            }
        }
    }

    // ========================================
    // BATTERY WIDGET WITH TOOLTIP
    // ========================================
    Component {
        id: batteryWidget

        Rectangle {
            id: batteryBtn
            width: batteryRow.implicitWidth + 16
            height: 30
            color: batteryMouse.containsMouse ? (settings ? Qt.rgba(batteryColor.r, batteryColor.g, batteryColor.b, 0.2) : Qt.rgba(0.651, 0.890, 0.631, 0.2)) : (settings ? settings.colorBackgroundAlt : Qt.rgba(0.118, 0.118, 0.18, 0.6))
            radius: settings ? settings.radiusSmall : 8
            border.width: batteryMouse.containsMouse ? 1 : 0
            border.color: settings ? Qt.rgba(batteryColor.r, batteryColor.g, batteryColor.b, 0.4) : Qt.rgba(0.651, 0.890, 0.631, 0.4)

            property color batteryColor: {
                if (bar.batteryCharging) return settings ? settings.colorAccent : "#89b4fa"
                if (bar.batteryPercent <= 20) return settings ? settings.colorError : "#f38ba8"
                if (bar.batteryPercent <= 40) return settings ? settings.colorWarning : "#fab387"
                return settings ? settings.colorSuccess : "#a6e3a1"
            }

            Behavior on color { ColorAnimation { duration: 150 } }

            RowLayout {
                id: batteryRow
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: {
                        if (bar.batteryCharging) return "󰂄"
                        if (bar.batteryPercent >= 90) return "󰁹"
                        if (bar.batteryPercent >= 80) return "󰂂"
                        if (bar.batteryPercent >= 70) return "󰂁"
                        if (bar.batteryPercent >= 60) return "󰂀"
                        if (bar.batteryPercent >= 50) return "󰁿"
                        if (bar.batteryPercent >= 40) return "󰁾"
                        if (bar.batteryPercent >= 30) return "󰁽"
                        if (bar.batteryPercent >= 20) return "󰁼"
                        if (bar.batteryPercent >= 10) return "󰁻"
                        return "󰁺"
                    }
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeIcon : 14
                    color: batteryBtn.batteryColor
                }

                Text {
                    text: bar.batteryPercent + "%"
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeLabel - 2 : 11
                    color: settings ? settings.colorText : "#cdd6f4"
                }
            }

            MouseArea {
                id: batteryMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: bar.closeAllPopups()
            }

            // Battery tooltip on hover
            Rectangle {
                id: batteryTooltip
                visible: batteryMouse.containsMouse
                width: tooltipContent.implicitWidth + 24
                height: tooltipContent.implicitHeight + 16
                x: -width + parent.width
                y: parent.height + 8
                z: 100
                color: settings ? Qt.rgba(settings.colorBackground.r, settings.colorBackground.g, settings.colorBackground.b, 0.95) : Qt.rgba(0.118, 0.118, 0.18, 0.95)
                radius: settings ? settings.radiusSmall : 8
                border.width: 1
                border.color: settings ? settings.colorBorder : "#45475a"

                ColumnLayout {
                    id: tooltipContent
                    anchors.centerIn: parent
                    spacing: 4

                    RowLayout {
                        spacing: 8

                        Text {
                            text: bar.batteryCharging ? "󰂄" : "󰁹"
                            font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                            color: batteryBtn.batteryColor
                        }

                        ColumnLayout {
                            spacing: 2

                            Text {
                                text: bar.batteryPercent + "% " + (bar.batteryCharging ? "Charging" : "Battery")
                                font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                                font.pixelSize: settings ? settings.fontSizeLabel : 12
                                font.bold: true
                                color: settings ? settings.colorText : "#cdd6f4"
                            }

                            Text {
                                text: bar.batteryStatus
                                font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                                font.pixelSize: settings ? settings.fontSizeLabel - 2 : 10
                                color: settings ? settings.colorTextDim : "#a6adc8"
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: screenshotWidget

        Rectangle {
            width: 40
            height: 30
            color: screenshotMouse.containsMouse ? (settings ? Qt.rgba(settings.colorAccent.r, settings.colorAccent.g, settings.colorAccent.b, 0.3) : Qt.rgba(0.537, 0.706, 0.98, 0.3)) : (settings ? settings.colorBackgroundAlt : Qt.rgba(0.118, 0.118, 0.18, 0.6))
            radius: settings ? settings.radiusSmall : 8

            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: "󰹑"
                font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                font.pixelSize: settings ? settings.fontSizeIcon : 16
                color: settings ? settings.colorPurple : "#cba6f7"
            }

            MouseArea {
                id: screenshotMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (mouse) => {
                    bar.closeAllPopups()
                    if (mouse.button === Qt.RightButton) {
                        bar.takeScreenshotFull()
                    } else {
                        bar.takeScreenshotRegion()
                    }
                }
            }
        }
    }

    Component {
        id: controlCenterWidget

        Rectangle {
            width: 40
            height: 30
            color: ccMouse.containsMouse ? (settings ? Qt.rgba(settings.colorAccentAlt.r, settings.colorAccentAlt.g, settings.colorAccentAlt.b, 0.3) : Qt.rgba(0.706, 0.706, 0.98, 0.3)) : (settings ? settings.colorBackgroundAlt : Qt.rgba(0.118, 0.118, 0.18, 0.6))
            radius: settings ? settings.radiusSmall : 8

            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: "󰒓"
                font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                font.pixelSize: settings ? settings.fontSizeIcon : 16
                color: settings ? settings.colorAccentAlt : "#b4befe"
            }

            MouseArea {
                id: ccMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    bar.closeAllPopups()
                    if (controlCenterComponent) {
                        controlCenterComponent.toggle()
                    }
                }
            }
        }
    }

    Component {
        id: powerWidget

        Rectangle {
            width: 40
            height: 32
            color: settings ? settings.colorBackgroundAlt : Qt.rgba(0.118, 0.118, 0.18, 0.6)
            radius: settings ? settings.radiusSmall : 8

            Text {
                anchors.centerIn: parent
                text: "󰐥"
                font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                font.pixelSize: settings ? settings.fontSizeIcon : 16
                color: settings ? settings.colorError : "#f38ba8"
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    bar.closeAllPopups()
                    powerMenuOpen = !powerMenuOpen
                }
            }
        }
    }
}

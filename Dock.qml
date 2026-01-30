import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

WlrLayershell {
    id: dock

    property var settings: null
    property int dockHeight: settings ? settings.dockHeight : 70
    property int tooltipHeight: 28
    property int revealHeight: settings ? settings.dockRevealHeight : 2
    property int marginBottom: settings ? settings.dockMarginBottom : 12
    property bool autohide: settings ? settings.dockAutoHide : true
    property bool shown: !autohide

    layer: WlrLayer.Top
    anchors {
        left: true
        right: true
        bottom: true
    }
    exclusiveZone: 0
    implicitHeight: dockHeight + tooltipHeight
    color: "transparent"
    margins.bottom: shown ? marginBottom : -(dockHeight + tooltipHeight - revealHeight)

    Behavior on margins.bottom {
        NumberAnimation {
            duration: 180
            easing.type: Easing.OutCubic
        }
    }

    property int iconHoverCount: 0

    Timer {
        id: hideTimer
        interval: 250
        repeat: false
        onTriggered: {
            if (autohide && !hoverArea.containsMouse && iconHoverCount === 0) shown = false
        }
    }

    // Hover detection area - includes tooltip space to prevent flicker
    MouseArea {
        id: hoverArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: dockHeight + tooltipHeight
        hoverEnabled: true
        propagateComposedEvents: true
        onEntered: {
            if (autohide) shown = true
            hideTimer.stop()
        }
        onExited: {
            if (autohide && iconHoverCount === 0) hideTimer.start()
        }
        // Allow all mouse events to pass through to dock icons
        onPressed: (mouse) => { mouse.accepted = false }
        onReleased: (mouse) => { mouse.accepted = false }
        onClicked: (mouse) => { mouse.accepted = false }
    }

    onAutohideChanged: {
        shown = !autohide
    }

    function onIconHoverChanged(entered) {
        if (entered) {
            iconHoverCount += 1
            if (autohide) shown = true
            hideTimer.stop()
        } else {
            iconHoverCount = Math.max(0, iconHoverCount - 1)
            if (autohide && iconHoverCount === 0 && !hoverArea.containsMouse) hideTimer.start()
        }
    }

    Rectangle {
        id: dockContent
        width: dockRow.implicitWidth + 24
        height: dockHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        color: settings ? Qt.rgba(settings.colorBackground.r, settings.colorBackground.g, settings.colorBackground.b, 0.85) : Qt.rgba(0.118, 0.118, 0.18, 0.85)
        radius: settings ? settings.dockRadius : 12
        border.width: settings ? settings.dockBorderWidth : 2
        border.color: settings ? settings.colorBorder : Qt.rgba(0.537, 0.706, 0.98, 0.2)

        RowLayout {
            id: dockRow
            anchors.centerIn: parent
            spacing: 8

            Repeater {
                model: settings ? settings.dockPinned : []

                DockIcon {
                    settings: dock.settings
                    dockRef: dock
                    appLaunchRef: appLaunch
                    iconText: modelData.icon
                    appName: modelData.name
                    appId: modelData.appId
                    command: modelData.command
                    isPinned: true
                    isRunning: isAppRunning(modelData.appId)
                }
            }

            Repeater {
                model: ToplevelManager.toplevels

                DockIcon {
                    settings: dock.settings
                    dockRef: dock
                    appLaunchRef: appLaunch
                    visible: modelData.appId !== "" && !dock.isPinned(modelData.appId)
                    iconText: appIconFor(modelData.appId)
                    appName: appNameFor(modelData.appId)
                    appId: modelData.appId
                    toplevel: modelData
                    isPinned: false
                    isRunning: true
                }
            }
        }
    }

    Process {
        id: appLaunch
    }

    function isPinned(appId) {
        if (!settings) return false
        var canonical = normalizeAppId(appId)
        var list = settings.dockPinned
        for (var i = 0; i < list.length; i++) {
            if (normalizeAppId(list[i].appId) === canonical) return true
        }
        return false
    }

    function isAppRunning(appId) {
        var list = ToplevelManager.toplevels
        var canonical = normalizeAppId(appId)
        for (var i = 0; i < list.count; i++) {
            var item = list.get(i)
            if (item && normalizeAppId(item.appId) === canonical) return true
        }
        return false
    }

    function appNameFor(appId) {
        var meta = findAppMeta(appId)
        if (meta && meta.name) return meta.name
        return appId || "App"
    }

    function appIconFor(appId) {
        var meta = findAppMeta(appId)
        if (meta && meta.icon) return meta.icon
        return "󰣆"
    }

    function appCommandFor(appId) {
        var meta = findAppMeta(appId)
        if (meta && meta.command) return meta.command
        return appId
    }

    function findAppMeta(appId) {
        for (var i = 0; i < appCatalog.length; i++) {
            var entry = appCatalog[i]
            for (var j = 0; j < entry.appIds.length; j++) {
                if (normalizeAppId(entry.appIds[j]) === normalizeAppId(appId)) return entry
            }
        }
        return null
    }

    function normalizeAppId(appId) {
        if (!appId) return ""
        var normalized = appId.toLowerCase()
        if (normalized.endsWith(".desktop")) {
            normalized = normalized.slice(0, -8)
        }
        normalized = normalized.replace(/_/g, "-")
        return normalized
    }

    function togglePinFromApp(appId) {
        if (!settings) return

        settings.toggleDockPinned({
            appId: normalizeAppId(appId),
            name: appNameFor(appId),
            icon: appIconFor(appId),
            command: appCommandFor(appId)
        })
    }

    property var appCatalog: [
        { name: "Firefox", icon: "󰈹", command: "firefox", appIds: ["firefox", "org.mozilla.firefox", "org.mozilla.Firefox"] },
        { name: "Chromium", icon: "󰊯", command: "chromium", appIds: ["chromium", "org.chromium.Chromium"] },
        { name: "Google Chrome", icon: "󰊯", command: "google-chrome-stable", appIds: ["google-chrome", "google-chrome-stable", "google-chrome.desktop", "chrome", "com.google.Chrome", "com.google.Chrome.desktop"] },
        { name: "Brave", icon: "󰖟", command: "brave", appIds: ["brave", "com.brave.Browser"] },
        { name: "Discord", icon: "󰙯", command: "discord", appIds: ["discord"] },
        { name: "Spotify", icon: "󰓇", command: "spotify", appIds: ["spotify"] },
        { name: "Telegram", icon: "󰄫", command: "telegram-desktop", appIds: ["telegram-desktop", "org.telegram.desktop"] },
        { name: "Alacritty", icon: "󰆍", command: "alacritty", appIds: ["alacritty"] },
        { name: "Terminal", icon: "󰆍", command: "alacritty", appIds: ["org.wezfurlong.wezterm", "kitty", "org.kde.konsole", "com.mitchellh.ghostty", "xterm", "org.gnome.Terminal", "org.gnome.Terminal.desktop"] },
        { name: "Files", icon: "󰉋", command: "thunar", appIds: ["thunar", "org.gnome.Nautilus", "org.kde.dolphin"] },
        { name: "VS Code", icon: "󰨞", command: "code", appIds: ["code", "code-oss", "code-url-handler", "com.microsoft.VSCode", "com.microsoft.VSCode.desktop", "visual-studio-code"] },
        { name: "VSCodium", icon: "󰨞", command: "codium", appIds: ["codium", "com.vscodium.codium", "com.vscodium.codium.desktop"] },
        { name: "Steam", icon: "󰓓", command: "steam", appIds: ["steam"] },
        { name: "Thunderbird", icon: "󰇰", command: "thunderbird", appIds: ["thunderbird", "org.mozilla.Thunderbird"] },
        { name: "Settings", icon: "󰒓", command: "gnome-control-center", appIds: ["gnome-control-center", "org.gnome.Settings"] },
        { name: "OBS", icon: "󰑋", command: "obs", appIds: ["obs", "com.obsproject.Studio"] },
        { name: "VLC", icon: "󰕼", command: "vlc", appIds: ["vlc", "org.videolan.VLC"] },
        { name: "MPV", icon: "󰐹", command: "mpv", appIds: ["mpv"] },
        { name: "GIMP", icon: "󰏘", command: "gimp", appIds: ["gimp", "org.gimp.GIMP"] }
    ]
}

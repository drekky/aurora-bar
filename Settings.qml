import QtQuick
import Quickshell
import QtCore

// Global settings - instantiate once in shell.qml
Item {
    id: settings
    visible: false

    // Persist settings across restarts
    Settings {
        id: persist
        category: "quickshell"
        location: Qt.resolvedUrl("settings.ini")

        // ========================================
        // CONTROL CENTER SETTINGS
        // ========================================

        // Position & Layout
        property string ccPosition: "top-right"
        property int ccWidth: 380
        property int ccMarginTop: 50
        property int ccMarginSide: 12
        property int ccPadding: 16
        property int ccCardSpacing: 12
        property int ccToggleColumns: 3

        // Animation
        property string ccAnimation: "slide"
        property int ccAnimationDuration: 250
        property real ccAnimationOvershoot: 1.1

        // Toggle Settings
        property int ccToggleHeight: 70
        property int ccToggleIconSize: 22

        // Slider Settings
        property int ccSliderHeight: 40
        property int ccSliderHandleSize: 20

        // ========================================
        // BAR SETTINGS
        // ========================================
        property int barHeight: 43
        property int barMarginTop: 8
        property int barMarginSide: 12
        property real barOpacity: 0.85
        property int barRadius: 12
        property int barBorderWidth: 2
        property string barWidgetsLeftJson: "[\"launcher\",\"workspaces\"]"
        property string barWidgetsCenterJson: "[\"clock\"]"
        property string barWidgetsRightJson: "[\"volume\",\"wifi\",\"battery\",\"screenshot\",\"controlCenter\",\"power\"]"
        property bool clockUse24h: true
        property bool clockShowDate: false
        property string clockTimeFormat: ""
        property string clockDateFormat: "yyyy-MM-dd"
        property int workspaceCount: 5

        // ========================================
        // DOCK SETTINGS
        // ========================================
        property int dockHeight: 70
        property int dockMarginBottom: 12
        property int dockRevealHeight: 2
        property bool dockAutoHide: true
        property int dockRadius: 12
        property int dockBorderWidth: 2
        property string dockPinnedJson: "[]"

        // ========================================
        // LAUNCHER SETTINGS
        // ========================================
        property int launcherWidth: 900
        property int launcherHeight: 700
        property int launcherColumns: 6
        property int launcherIconSize: 48
        property int launcherRadius: 16
        property int launcherBorderWidth: 2

        // ========================================
        // SETTINGS PANEL SETTINGS
        // ========================================
        property int settingsPanelRadius: 16
        property int settingsPanelBorderWidth: 2

        // ========================================
        // CONTROL CENTER SETTINGS - Appearance
        // ========================================
        property int ccPanelRadius: 16
        property int ccCardRadius: 12
        property int ccPanelBorderWidth: 2

        // ========================================
        // GLOBAL THEME
        // ========================================

        // Shapes
        property int radiusLarge: 16
        property int radiusMedium: 12
        property int radiusSmall: 8
        property int borderWidth: 2

        // Typography
        property string fontFamily: "JetBrainsMono Nerd Font"
        property int fontSizeHeader: 14
        property int fontSizeLabel: 12
        property int fontSizeValue: 24
        property int fontSizeIcon: 18

        // Colors - Base
        property color colorBackground: "#1e1e2e"
        property color colorBackgroundAlt: "#313244"
        property color colorSurface: "#45475a"
        property color colorBorder: "#585b70"

        // Colors - Text
        property color colorText: "#cdd6f4"
        property color colorTextDim: "#a6adc8"
        property color colorTextMuted: "#6c7086"

        // Colors - Accent
        property color colorAccent: "#89b4fa"
        property color colorAccentAlt: "#b4befe"

        // Colors - Semantic
        property color colorSuccess: "#a6e3a1"
        property color colorWarning: "#f9e2af"
        property color colorError: "#f38ba8"
        property color colorInfo: "#89dceb"

        // Colors - Special
        property color colorPurple: "#cba6f7"
        property color colorTeal: "#94e2d5"
        property color colorPink: "#f5c2e7"
        property color colorPeach: "#fab387"
    }

    // ========================================
    // EXPOSE ALL PROPERTIES (read-only access)
    // ========================================

    // Control Center
    readonly property string ccPosition: persist.ccPosition
    readonly property int ccWidth: persist.ccWidth
    readonly property int ccMarginTop: persist.ccMarginTop
    readonly property int ccMarginSide: persist.ccMarginSide
    readonly property int ccPadding: persist.ccPadding
    readonly property int ccCardSpacing: persist.ccCardSpacing
    readonly property int ccToggleColumns: persist.ccToggleColumns
    readonly property string ccAnimation: persist.ccAnimation
    readonly property int ccAnimationDuration: persist.ccAnimationDuration
    readonly property real ccAnimationOvershoot: persist.ccAnimationOvershoot
    readonly property int ccToggleHeight: persist.ccToggleHeight
    readonly property int ccToggleIconSize: persist.ccToggleIconSize
    readonly property int ccSliderHeight: persist.ccSliderHeight
    readonly property int ccSliderHandleSize: persist.ccSliderHandleSize

    // Bar
    readonly property int barHeight: persist.barHeight
    readonly property int barMarginTop: persist.barMarginTop
    readonly property int barMarginSide: persist.barMarginSide
    readonly property real barOpacity: persist.barOpacity
    readonly property int barRadius: persist.barRadius
    readonly property int barBorderWidth: persist.barBorderWidth
    readonly property var barWidgetsLeft: parseBarWidgets(persist.barWidgetsLeftJson)
    readonly property var barWidgetsCenter: parseBarWidgets(persist.barWidgetsCenterJson)
    readonly property var barWidgetsRight: parseBarWidgets(persist.barWidgetsRightJson)
    readonly property bool clockUse24h: persist.clockUse24h
    readonly property bool clockShowDate: persist.clockShowDate
    readonly property string clockTimeFormat: persist.clockTimeFormat
    readonly property string clockDateFormat: persist.clockDateFormat
    readonly property int workspaceCount: persist.workspaceCount

    // Dock
    readonly property int dockHeight: persist.dockHeight
    readonly property int dockMarginBottom: persist.dockMarginBottom
    readonly property int dockRevealHeight: persist.dockRevealHeight
    readonly property bool dockAutoHide: persist.dockAutoHide
    readonly property int dockRadius: persist.dockRadius
    readonly property int dockBorderWidth: persist.dockBorderWidth
    readonly property var dockPinned: parseDockPinned()

    // Launcher
    readonly property int launcherWidth: persist.launcherWidth
    readonly property int launcherHeight: persist.launcherHeight
    readonly property int launcherColumns: persist.launcherColumns
    readonly property int launcherIconSize: persist.launcherIconSize
    readonly property int launcherRadius: persist.launcherRadius
    readonly property int launcherBorderWidth: persist.launcherBorderWidth

    // Settings Panel
    readonly property int settingsPanelRadius: persist.settingsPanelRadius
    readonly property int settingsPanelBorderWidth: persist.settingsPanelBorderWidth

    // Control Center Appearance
    readonly property int ccPanelRadius: persist.ccPanelRadius
    readonly property int ccCardRadius: persist.ccCardRadius
    readonly property int ccPanelBorderWidth: persist.ccPanelBorderWidth

    // Theme - Shapes
    readonly property int radiusLarge: persist.radiusLarge
    readonly property int radiusMedium: persist.radiusMedium
    readonly property int radiusSmall: persist.radiusSmall
    readonly property int borderWidth: persist.borderWidth

    // Theme - Typography
    readonly property string fontFamily: persist.fontFamily
    readonly property int fontSizeHeader: persist.fontSizeHeader
    readonly property int fontSizeLabel: persist.fontSizeLabel
    readonly property int fontSizeValue: persist.fontSizeValue
    readonly property int fontSizeIcon: persist.fontSizeIcon

    // Theme - Colors
    readonly property color colorBackground: persist.colorBackground
    readonly property color colorBackgroundAlt: persist.colorBackgroundAlt
    readonly property color colorSurface: persist.colorSurface
    readonly property color colorBorder: persist.colorBorder
    readonly property color colorText: persist.colorText
    readonly property color colorTextDim: persist.colorTextDim
    readonly property color colorTextMuted: persist.colorTextMuted
    readonly property color colorAccent: persist.colorAccent
    readonly property color colorAccentAlt: persist.colorAccentAlt
    readonly property color colorSuccess: persist.colorSuccess
    readonly property color colorWarning: persist.colorWarning
    readonly property color colorError: persist.colorError
    readonly property color colorInfo: persist.colorInfo
    readonly property color colorPurple: persist.colorPurple
    readonly property color colorTeal: persist.colorTeal
    readonly property color colorPink: persist.colorPink
    readonly property color colorPeach: persist.colorPeach

    // ========================================
    // SETTER FUNCTIONS
    // ========================================

    // Control Center setters
    function setCcPosition(val) { persist.ccPosition = val }
    function setCcWidth(val) { persist.ccWidth = val }
    function setCcMarginTop(val) { persist.ccMarginTop = val }
    function setCcMarginSide(val) { persist.ccMarginSide = val }
    function setCcPadding(val) { persist.ccPadding = val }
    function setCcCardSpacing(val) { persist.ccCardSpacing = val }
    function setCcToggleColumns(val) { persist.ccToggleColumns = val }
    function setCcAnimation(val) { persist.ccAnimation = val }
    function setCcAnimationDuration(val) { persist.ccAnimationDuration = val }
    function setCcAnimationOvershoot(val) { persist.ccAnimationOvershoot = val }
    function setCcToggleHeight(val) { persist.ccToggleHeight = val }
    function setCcToggleIconSize(val) { persist.ccToggleIconSize = val }
    function setCcSliderHeight(val) { persist.ccSliderHeight = val }
    function setCcSliderHandleSize(val) { persist.ccSliderHandleSize = val }

    // Bar setters
    function setBarHeight(val) { persist.barHeight = val }
    function setBarMarginTop(val) { persist.barMarginTop = val }
    function setBarMarginSide(val) { persist.barMarginSide = val }
    function setBarOpacity(val) { persist.barOpacity = val }
    function setBarRadius(val) { persist.barRadius = val }
    function setBarBorderWidth(val) { persist.barBorderWidth = val }
    function setClockUse24h(val) { persist.clockUse24h = val }
    function setClockShowDate(val) { persist.clockShowDate = val }
    function setClockTimeFormat(val) { persist.clockTimeFormat = val }
    function setClockDateFormat(val) { persist.clockDateFormat = val }
    function setWorkspaceCount(val) { persist.workspaceCount = val }

    // Dock setters
    function setDockHeight(val) { persist.dockHeight = val }
    function setDockMarginBottom(val) { persist.dockMarginBottom = val }
    function setDockRevealHeight(val) { persist.dockRevealHeight = val }
    function setDockAutoHide(val) { persist.dockAutoHide = val }
    function setDockRadius(val) { persist.dockRadius = val }
    function setDockBorderWidth(val) { persist.dockBorderWidth = val }
    function setDockPinned(list) { persist.dockPinnedJson = JSON.stringify(list) }

    // Launcher setters
    function setLauncherWidth(val) { persist.launcherWidth = val }
    function setLauncherHeight(val) { persist.launcherHeight = val }
    function setLauncherColumns(val) { persist.launcherColumns = val }
    function setLauncherIconSize(val) { persist.launcherIconSize = val }
    function setLauncherRadius(val) { persist.launcherRadius = val }
    function setLauncherBorderWidth(val) { persist.launcherBorderWidth = val }

    // Settings panel setters
    function setSettingsPanelRadius(val) { persist.settingsPanelRadius = val }
    function setSettingsPanelBorderWidth(val) { persist.settingsPanelBorderWidth = val }

    // Control center appearance setters
    function setCcPanelRadius(val) { persist.ccPanelRadius = val }
    function setCcCardRadius(val) { persist.ccCardRadius = val }
    function setCcPanelBorderWidth(val) { persist.ccPanelBorderWidth = val }

    // Theme setters
    function setRadiusLarge(val) { persist.radiusLarge = val }
    function setRadiusMedium(val) { persist.radiusMedium = val }
    function setRadiusSmall(val) { persist.radiusSmall = val }
    function setBorderWidth(val) { persist.borderWidth = val }
    function setFontFamily(val) { persist.fontFamily = val }
    function setFontSizeHeader(val) { persist.fontSizeHeader = val }
    function setFontSizeLabel(val) { persist.fontSizeLabel = val }
    function setFontSizeValue(val) { persist.fontSizeValue = val }
    function setFontSizeIcon(val) { persist.fontSizeIcon = val }

    // Color setters
    function setColorBackground(val) { persist.colorBackground = val }
    function setColorBackgroundAlt(val) { persist.colorBackgroundAlt = val }
    function setColorSurface(val) { persist.colorSurface = val }
    function setColorBorder(val) { persist.colorBorder = val }
    function setColorText(val) { persist.colorText = val }
    function setColorTextDim(val) { persist.colorTextDim = val }
    function setColorTextMuted(val) { persist.colorTextMuted = val }
    function setColorAccent(val) { persist.colorAccent = val }
    function setColorAccentAlt(val) { persist.colorAccentAlt = val }
    function setColorSuccess(val) { persist.colorSuccess = val }
    function setColorWarning(val) { persist.colorWarning = val }
    function setColorError(val) { persist.colorError = val }
    function setColorInfo(val) { persist.colorInfo = val }
    function setColorPurple(val) { persist.colorPurple = val }
    function setColorTeal(val) { persist.colorTeal = val }
    function setColorPink(val) { persist.colorPink = val }
    function setColorPeach(val) { persist.colorPeach = val }

    function parseBarWidgets(json) {
        try {
            var parsed = JSON.parse(json)
            return Array.isArray(parsed) ? parsed : []
        } catch (e) {
            return []
        }
    }

    function barWidgetPlacement(widgetId) {
        var left = parseBarWidgets(persist.barWidgetsLeftJson)
        var center = parseBarWidgets(persist.barWidgetsCenterJson)
        var right = parseBarWidgets(persist.barWidgetsRightJson)

        if (left.indexOf(widgetId) >= 0) return "left"
        if (center.indexOf(widgetId) >= 0) return "center"
        if (right.indexOf(widgetId) >= 0) return "right"
        return "hidden"
    }

    function setBarWidgetPlacement(widgetId, placement) {
        var left = parseBarWidgets(persist.barWidgetsLeftJson)
        var center = parseBarWidgets(persist.barWidgetsCenterJson)
        var right = parseBarWidgets(persist.barWidgetsRightJson)

        left = left.filter(function(item) { return item !== widgetId })
        center = center.filter(function(item) { return item !== widgetId })
        right = right.filter(function(item) { return item !== widgetId })

        if (placement === "left") left.push(widgetId)
        if (placement === "center") center.push(widgetId)
        if (placement === "right") right.push(widgetId)

        persist.barWidgetsLeftJson = JSON.stringify(left)
        persist.barWidgetsCenterJson = JSON.stringify(center)
        persist.barWidgetsRightJson = JSON.stringify(right)
    }

    function parseDockPinned() {
        try {
            var parsed = JSON.parse(persist.dockPinnedJson)
            return Array.isArray(parsed) ? parsed : []
        } catch (e) {
            return []
        }
    }

    function isDockPinned(appId) {
        var list = parseDockPinned()
        for (var i = 0; i < list.length; i++) {
            if (list[i].appId === appId) return true
        }
        return false
    }

    function toggleDockPinned(entry) {
        var list = parseDockPinned()
        var idx = -1
        for (var i = 0; i < list.length; i++) {
            if (list[i].appId === entry.appId) {
                idx = i
                break
            }
        }

        if (idx >= 0) {
            list.splice(idx, 1)
        } else {
            list.push(entry)
        }

        setDockPinned(list)
    }

    // Reset to defaults
    function resetAll() {
        // Control Center
        persist.ccPosition = "top-right"
        persist.ccWidth = 380
        persist.ccMarginTop = 50
        persist.ccMarginSide = 12
        persist.ccPadding = 16
        persist.ccCardSpacing = 12
        persist.ccToggleColumns = 3
        persist.ccAnimation = "slide"
        persist.ccAnimationDuration = 250
        persist.ccAnimationOvershoot = 1.1
        persist.ccToggleHeight = 70
        persist.ccToggleIconSize = 22
        persist.ccSliderHeight = 40
        persist.ccSliderHandleSize = 20

        // Bar
        persist.barHeight = 43
        persist.barMarginTop = 8
        persist.barMarginSide = 12
        persist.barOpacity = 0.85
        persist.barRadius = 12
        persist.barBorderWidth = 2
        persist.barWidgetsLeftJson = "[\"launcher\",\"workspaces\"]"
        persist.barWidgetsCenterJson = "[\"clock\"]"
        persist.barWidgetsRightJson = "[\"volume\",\"wifi\",\"battery\",\"screenshot\",\"controlCenter\",\"power\"]"
        persist.clockUse24h = true
        persist.clockShowDate = false
        persist.clockTimeFormat = ""
        persist.clockDateFormat = "yyyy-MM-dd"
        persist.workspaceCount = 5

        // Dock
        persist.dockHeight = 70
        persist.dockMarginBottom = 12
        persist.dockRevealHeight = 2
        persist.dockAutoHide = true
        persist.dockRadius = 12
        persist.dockBorderWidth = 2
        persist.dockPinnedJson = "[]"

        // Launcher
        persist.launcherWidth = 900
        persist.launcherHeight = 700
        persist.launcherColumns = 6
        persist.launcherIconSize = 48
        persist.launcherRadius = 16
        persist.launcherBorderWidth = 2

        // Settings Panel
        persist.settingsPanelRadius = 16
        persist.settingsPanelBorderWidth = 2

        // Control Center Appearance
        persist.ccPanelRadius = 16
        persist.ccCardRadius = 12
        persist.ccPanelBorderWidth = 2

        // Shapes
        persist.radiusLarge = 16
        persist.radiusMedium = 12
        persist.radiusSmall = 8
        persist.borderWidth = 2

        // Typography
        persist.fontFamily = "JetBrainsMono Nerd Font"
        persist.fontSizeHeader = 14
        persist.fontSizeLabel = 12
        persist.fontSizeValue = 24
        persist.fontSizeIcon = 18

        // Colors
        persist.colorBackground = "#1e1e2e"
        persist.colorBackgroundAlt = "#313244"
        persist.colorSurface = "#45475a"
        persist.colorBorder = "#585b70"
        persist.colorText = "#cdd6f4"
        persist.colorTextDim = "#a6adc8"
        persist.colorTextMuted = "#6c7086"
        persist.colorAccent = "#89b4fa"
        persist.colorAccentAlt = "#b4befe"
        persist.colorSuccess = "#a6e3a1"
        persist.colorWarning = "#f9e2af"
        persist.colorError = "#f38ba8"
        persist.colorInfo = "#89dceb"
        persist.colorPurple = "#cba6f7"
        persist.colorTeal = "#94e2d5"
        persist.colorPink = "#f5c2e7"
        persist.colorPeach = "#fab387"
    }
}

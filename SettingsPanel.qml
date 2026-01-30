import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

WlrLayershell {
    id: settingsPanel

    property var settings: null
    property bool panelVisible: false
    property var colorPalette: [
        "#1e1e2e", "#313244", "#45475a", "#585b70",
        "#cdd6f4", "#a6adc8", "#6c7086", "#89b4fa",
        "#b4befe", "#a6e3a1", "#f9e2af", "#f38ba8",
        "#89dceb", "#cba6f7", "#94e2d5", "#f5c2e7",
        "#fab387"
    ]
    property var base16Schemes: [
        {
            name: "Base16 Ocean",
            base00: "#2B303B",
            base01: "#343D46",
            base02: "#4F5B66",
            base03: "#65737E",
            base04: "#A7ADBA",
            base05: "#C0C5CE",
            base06: "#DFE1E8",
            base07: "#EFF1F5",
            base08: "#BF616A",
            base09: "#D08770",
            base0A: "#EBCB8B",
            base0B: "#A3BE8C",
            base0C: "#96B5B4",
            base0D: "#8FA1B3",
            base0E: "#B48EAD",
            base0F: "#AB7967"
        },
        {
            name: "Base16 Solarized Dark",
            base00: "#002B36",
            base01: "#073642",
            base02: "#586E75",
            base03: "#657B83",
            base04: "#839496",
            base05: "#93A1A1",
            base06: "#EEE8D5",
            base07: "#FDF6E3",
            base08: "#DC322F",
            base09: "#CB4B16",
            base0A: "#B58900",
            base0B: "#859900",
            base0C: "#2AA198",
            base0D: "#268BD2",
            base0E: "#6C71C4",
            base0F: "#D33682"
        },
        {
            name: "Base16 Solarized Light",
            base00: "#FDF6E3",
            base01: "#EEE8D5",
            base02: "#93A1A1",
            base03: "#839496",
            base04: "#657B83",
            base05: "#586E75",
            base06: "#073642",
            base07: "#002B36",
            base08: "#DC322F",
            base09: "#CB4B16",
            base0A: "#B58900",
            base0B: "#859900",
            base0C: "#2AA198",
            base0D: "#268BD2",
            base0E: "#6C71C4",
            base0F: "#D33682"
        },
        {
            name: "Base16 Gruvbox Dark",
            base00: "#282828",
            base01: "#3C3836",
            base02: "#504945",
            base03: "#665C54",
            base04: "#BDAE93",
            base05: "#D5C4A1",
            base06: "#EBDBB2",
            base07: "#FBF1C7",
            base08: "#FB4934",
            base09: "#FE8019",
            base0A: "#FABD2F",
            base0B: "#B8BB26",
            base0C: "#8EC07C",
            base0D: "#83A598",
            base0E: "#D3869B",
            base0F: "#D65D0E"
        },
        {
            name: "Base16 Gruvbox Light",
            base00: "#FBF1C7",
            base01: "#EBDBB2",
            base02: "#D5C4A1",
            base03: "#BDAE93",
            base04: "#665C54",
            base05: "#504945",
            base06: "#3C3836",
            base07: "#282828",
            base08: "#9D0006",
            base09: "#AF3A03",
            base0A: "#B57614",
            base0B: "#79740E",
            base0C: "#427B58",
            base0D: "#076678",
            base0E: "#8F3F71",
            base0F: "#D65D0E"
        },
        {
            name: "Base16 Tomorrow Night",
            base00: "#1D1F21",
            base01: "#282A2E",
            base02: "#373B41",
            base03: "#969896",
            base04: "#B4B7B4",
            base05: "#C5C8C6",
            base06: "#E0E0E0",
            base07: "#FFFFFF",
            base08: "#CC6666",
            base09: "#DE935F",
            base0A: "#F0C674",
            base0B: "#B5BD68",
            base0C: "#8ABEB7",
            base0D: "#81A2BE",
            base0E: "#B294BB",
            base0F: "#A3685A"
        },
        {
            name: "Base16 OneDark",
            base00: "#282C34",
            base01: "#353B45",
            base02: "#3E4451",
            base03: "#545862",
            base04: "#565C64",
            base05: "#ABB2BF",
            base06: "#B6BDCA",
            base07: "#C8CCD4",
            base08: "#E06C75",
            base09: "#D19A66",
            base0A: "#E5C07B",
            base0B: "#98C379",
            base0C: "#56B6C2",
            base0D: "#61AFEF",
            base0E: "#C678DD",
            base0F: "#BE5046"
        },
        {
            name: "Base16 Monokai",
            base00: "#272822",
            base01: "#383830",
            base02: "#49483E",
            base03: "#75715E",
            base04: "#A59F85",
            base05: "#F8F8F2",
            base06: "#F5F4F1",
            base07: "#F9F8F5",
            base08: "#F92672",
            base09: "#FD971F",
            base0A: "#F4BF75",
            base0B: "#A6E22E",
            base0C: "#A1EFE4",
            base0D: "#66D9EF",
            base0E: "#AE81FF",
            base0F: "#CC6633"
        },
        {
            name: "Base16 Eighties",
            base00: "#2D2D2D",
            base01: "#393939",
            base02: "#515151",
            base03: "#747369",
            base04: "#A09F93",
            base05: "#D3D0C8",
            base06: "#E8E6DF",
            base07: "#F2F0EC",
            base08: "#F2777A",
            base09: "#F99157",
            base0A: "#FFCC66",
            base0B: "#99CC99",
            base0C: "#66CCCC",
            base0D: "#6699CC",
            base0E: "#CC99CC",
            base0F: "#D27B53"
        },
        {
            name: "Base16 Nord",
            base00: "#2E3440",
            base01: "#3B4252",
            base02: "#434C5E",
            base03: "#4C566A",
            base04: "#D8DEE9",
            base05: "#E5E9F0",
            base06: "#ECEFF4",
            base07: "#8FBCBB",
            base08: "#BF616A",
            base09: "#D08770",
            base0A: "#EBCB8B",
            base0B: "#A3BE8C",
            base0C: "#88C0D0",
            base0D: "#81A1C1",
            base0E: "#B48EAD",
            base0F: "#5E81AC"
        }
    ]

    function toggle() { panelVisible = !panelVisible }
    function show() { panelVisible = true }
    function hide() { panelVisible = false }
    function applyAndReload() {
        Quickshell.reload(false)
    }
    function applyBase16(scheme) {
        settings.setColorBackground(scheme.base00)
        settings.setColorBackgroundAlt(scheme.base01)
        settings.setColorSurface(scheme.base02)
        settings.setColorBorder(scheme.base03)

        settings.setColorTextMuted(scheme.base03)
        settings.setColorTextDim(scheme.base04)
        settings.setColorText(scheme.base05)

        settings.setColorAccent(scheme.base0D)
        settings.setColorAccentAlt(scheme.base0E)

        settings.setColorSuccess(scheme.base0B)
        settings.setColorWarning(scheme.base0A)
        settings.setColorError(scheme.base08)
        settings.setColorInfo(scheme.base0C)

        settings.setColorPurple(scheme.base0E)
        settings.setColorTeal(scheme.base0C)
        settings.setColorPink(scheme.base0F)
        settings.setColorPeach(scheme.base09)
    }

    layer: WlrLayer.Overlay
    keyboardFocus: WlrKeyboardFocus.OnDemand
    exclusiveZone: 0
    namespace: "settings-panel"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"
    visible: panelVisible

    // Current section
    property string currentSection: "bar"

    // Background overlay
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: panelVisible ? 0.6 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        MouseArea {
            anchors.fill: parent
            onClicked: settingsPanel.hide()
        }
    }

    // Main panel
    Rectangle {
        id: panel
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.85, 800)
        height: Math.min(parent.height * 0.85, 600)
        color: settings.colorBackground
        radius: settings.settingsPanelRadius
        border.width: settings.settingsPanelBorderWidth
        border.color: settings.colorBorder

        opacity: panelVisible ? 1 : 0
        scale: panelVisible ? 1 : 0.95

        Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            // Sidebar
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: 200
                color: settings.colorBackgroundAlt
                radius: settings.radiusLarge

                // Clip the right corners
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: settings.radiusLarge
                    color: parent.color
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    // Header
                    Text {
                        text: "󰒓  Settings"
                        font.family: settings.fontFamily
                        font.pixelSize: 18
                        font.bold: true
                        color: settings.colorText
                        Layout.bottomMargin: 12
                    }

                    Flickable {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        contentHeight: navColumn.implicitHeight
                        clip: true

                        ColumnLayout {
                            id: navColumn
                            width: parent.width
                            spacing: 4

                            Repeater {
                                model: [
                                    { id: "bar", icon: "󰌨", label: "Bar" },
                                    { id: "controlCenter", icon: "󰒓", label: "Control Center" },
                                    { id: "launcher", icon: "󰈹", label: "Launcher" },
                                    { id: "dock", icon: "󰘔", label: "Dock" },
                                    { id: "settingsPanel", icon: "󰍹", label: "Settings Panel" },
                                    { id: "quickSettings", icon: "󰖩", label: "Quick Settings" },
                                    { id: "notifications", icon: "󰂚", label: "Notifications" },
                                    { id: "calendar", icon: "󰃭", label: "Calendar" },
                                    { id: "music", icon: "󰎈", label: "Music Player" },
                                    { id: "systemMonitor", icon: "󰍛", label: "System Monitor" },
                                    { id: "theme", icon: "󰌁", label: "Theme" },
                                    { id: "about", icon: "󰋼", label: "About" }
                                ]

                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    height: 40
                                    radius: settings.radiusSmall
                                    color: currentSection === modelData.id ?
                                           Qt.rgba(settings.colorAccent.r, settings.colorAccent.g, settings.colorAccent.b, 0.2) :
                                           (navMouse.containsMouse ? settings.colorSurface : "transparent")

                                    Behavior on color { ColorAnimation { duration: 150 } }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 12
                                        anchors.rightMargin: 12
                                        spacing: 10

                                        Text {
                                            text: modelData.icon
                                            font.family: settings.fontFamily
                                            font.pixelSize: 16
                                            color: currentSection === modelData.id ? settings.colorAccent : settings.colorTextDim
                                        }

                                        Text {
                                            text: modelData.label
                                            font.family: settings.fontFamily
                                            font.pixelSize: 13
                                            color: currentSection === modelData.id ? settings.colorText : settings.colorTextDim
                                            Layout.fillWidth: true
                                        }
                                    }

                                    MouseArea {
                                        id: navMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: currentSection = modelData.id
                                    }
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Rectangle {
                            Layout.fillWidth: true
                            height: 36
                            radius: settings.radiusSmall
                            color: resetMouse.containsMouse ? Qt.rgba(settings.colorError.r, settings.colorError.g, settings.colorError.b, 0.2) : "transparent"
                            border.width: 1
                            border.color: settings.colorError

                            Text {
                                anchors.centerIn: parent
                                text: "󰦛  Reset All"
                                font.family: settings.fontFamily
                                font.pixelSize: 12
                                color: settings.colorError
                            }

                            MouseArea {
                                id: resetMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: settings.resetAll()
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 36
                            radius: settings.radiusSmall
                            color: applyMouse.containsMouse ? Qt.rgba(settings.colorAccent.r, settings.colorAccent.g, settings.colorAccent.b, 0.2) : "transparent"
                            border.width: 1
                            border.color: settings.colorAccent

                            Text {
                                anchors.centerIn: parent
                                text: "󰁨  Apply & Reload"
                                font.family: settings.fontFamily
                                font.pixelSize: 12
                                color: settings.colorAccent
                            }

                            MouseArea {
                                id: applyMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: settingsPanel.applyAndReload()
                            }
                        }
                    }
                }
            }

            // Content area
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                Flickable {
                    anchors.fill: parent
                    anchors.margins: 20
                    contentHeight: contentLoader.height
                    clip: true

                    Loader {
                        id: contentLoader
                        width: parent.width
                        sourceComponent: {
                            switch(currentSection) {
                                case "bar": return barSection
                                case "controlCenter": return controlCenterSection
                                case "launcher": return launcherSection
                                case "dock": return dockSection
                                case "settingsPanel": return settingsPanelSection
                                case "quickSettings": return quickSettingsSection
                                case "notifications": return notificationsSection
                                case "calendar": return calendarSection
                                case "music": return musicSection
                                case "systemMonitor": return systemMonitorSection
                                case "theme": return themeSection
                                case "about": return aboutSection
                                default: return barSection
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }
                }
            }
        }

        // Close button
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12
            width: 32
            height: 32
            radius: 16
            color: closeMouse.containsMouse ? settings.colorSurface : "transparent"

            Text {
                anchors.centerIn: parent
                text: "󰅖"
                font.family: settings.fontFamily
                font.pixelSize: 16
                color: settings.colorTextDim
            }

            MouseArea {
                id: closeMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: settingsPanel.hide()
            }
        }
    }

    // ========================================
    // SECTION COMPONENTS
    // ========================================

    Component {
        id: barSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Bar"; icon: "󰌨" }

            SettingsCard {
                title: "Appearance"
                description: "Bar colors and shape"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Opacity"
                        value: Math.round(settings.barOpacity * 100)
                        from: 50; to: 100
                        suffix: "%"
                        onChanged: (val) => settings.setBarOpacity(val / 100)
                    }

                    SliderSetting {
                        label: "Corner radius"
                        value: settings.barRadius
                        from: 0; to: 24
                        onChanged: (val) => settings.setBarRadius(val)
                    }

                    SliderSetting {
                        label: "Border width"
                        value: settings.barBorderWidth
                        from: 0; to: 4
                        onChanged: (val) => settings.setBarBorderWidth(val)
                    }
                }
            }

            SettingsCard {
                title: "Behavior"
                description: "Bar size and position"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Height"
                        value: settings.barHeight
                        from: 30; to: 60
                        onChanged: (val) => settings.setBarHeight(val)
                    }

                    SliderSetting {
                        label: "Top margin"
                        value: settings.barMarginTop
                        from: 0; to: 20
                        onChanged: (val) => settings.setBarMarginTop(val)
                    }

                    SliderSetting {
                        label: "Side margin"
                        value: settings.barMarginSide
                        from: 0; to: 30
                        onChanged: (val) => settings.setBarMarginSide(val)
                    }
                }
            }

            SettingsCard {
                title: "Widgets"
                description: "Place widgets left, center, right, or hide"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Repeater {
                        model: [
                            { id: "launcher", label: "Launcher" },
                            { id: "workspaces", label: "Workspaces" },
                            { id: "clock", label: "Clock" },
                            { id: "systemTray", label: "System Tray" },
                            { id: "screenshot", label: "Screenshot" },
                            { id: "controlCenter", label: "Control Center" },
                            { id: "power", label: "Power" }
                        ]

                        OptionSetting {
                            label: modelData.label
                            options: ["left", "center", "right", "hidden"]
                            value: settings.barWidgetPlacement(modelData.id)
                            onChanged: (val) => settings.setBarWidgetPlacement(modelData.id, val)
                        }
                    }
                }
            }

            SettingsCard {
                title: "Clock"
                description: "Time and date formatting"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    ToggleSetting {
                        label: "24 hour time"
                        value: settings.clockUse24h
                        onChanged: (val) => settings.setClockUse24h(val)
                    }

                    ToggleSetting {
                        label: "Show date"
                        value: settings.clockShowDate
                        onChanged: (val) => settings.setClockShowDate(val)
                    }

                    TextInputSetting {
                        label: "Time format"
                        value: settings.clockTimeFormat
                        onChanged: (val) => settings.setClockTimeFormat(val)
                    }

                    FormatPresets {
                        presets: [
                            { label: "HH:mm", value: "HH:mm" },
                            { label: "HH:mm:ss", value: "HH:mm:ss" },
                            { label: "hh:mm ap", value: "hh:mm ap" },
                            { label: "h:mm ap", value: "h:mm ap" }
                        ]
                        onSelected: (val) => settings.setClockTimeFormat(val)
                    }

                    TextInputSetting {
                        label: "Date format"
                        value: settings.clockDateFormat
                        onChanged: (val) => settings.setClockDateFormat(val)
                    }

                    FormatPresets {
                        presets: [
                            { label: "yyyy-MM-dd", value: "yyyy-MM-dd" },
                            { label: "MM/dd/yy", value: "MM/dd/yy" },
                            { label: "dd/MM/yy", value: "dd/MM/yy" },
                            { label: "MMM dd", value: "MMM dd" }
                        ]
                        onSelected: (val) => settings.setClockDateFormat(val)
                    }
                }
            }

            SettingsCard {
                title: "Workspaces"
                description: "Workspace indicator count"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Count"
                        value: settings.workspaceCount
                        from: 1; to: 10
                        onChanged: (val) => settings.setWorkspaceCount(val)
                    }
                }
            }

            SettingsCard {
                title: "Animations"
                description: "No animation settings yet"
            }
        }
    }

    Component {
        id: controlCenterSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Control Center"; icon: "󰒓" }

            SettingsCard {
                title: "Appearance"
                description: "Panel and card styling"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Panel radius"
                        value: settings.ccPanelRadius
                        from: 0; to: 32
                        onChanged: (val) => settings.setCcPanelRadius(val)
                    }

                    SliderSetting {
                        label: "Panel border"
                        value: settings.ccPanelBorderWidth
                        from: 0; to: 4
                        onChanged: (val) => settings.setCcPanelBorderWidth(val)
                    }

                    SliderSetting {
                        label: "Card radius"
                        value: settings.ccCardRadius
                        from: 0; to: 24
                        onChanged: (val) => settings.setCcCardRadius(val)
                    }
                }
            }

            SettingsCard {
                title: "Behavior"
                description: "Layout and control sizing"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    OptionSetting {
                        label: "Position"
                        options: ["top-left", "top-center", "top-right"]
                        value: settings.ccPosition
                        onChanged: (val) => settings.setCcPosition(val)
                    }

                    SliderSetting {
                        label: "Panel width"
                        value: settings.ccWidth
                        from: 300; to: 500
                        onChanged: (val) => settings.setCcWidth(val)
                    }

                    SliderSetting {
                        label: "Top margin"
                        value: settings.ccMarginTop
                        from: 0; to: 100
                        onChanged: (val) => settings.setCcMarginTop(val)
                    }

                    SliderSetting {
                        label: "Side margin"
                        value: settings.ccMarginSide
                        from: 0; to: 50
                        onChanged: (val) => settings.setCcMarginSide(val)
                    }

                    SliderSetting {
                        label: "Padding"
                        value: settings.ccPadding
                        from: 8; to: 32
                        onChanged: (val) => settings.setCcPadding(val)
                    }

                    SliderSetting {
                        label: "Card spacing"
                        value: settings.ccCardSpacing
                        from: 4; to: 24
                        onChanged: (val) => settings.setCcCardSpacing(val)
                    }

                    SliderSetting {
                        label: "Toggle columns"
                        value: settings.ccToggleColumns
                        from: 2; to: 4
                        onChanged: (val) => settings.setCcToggleColumns(val)
                    }

                    SliderSetting {
                        label: "Toggle height"
                        value: settings.ccToggleHeight
                        from: 50; to: 100
                        onChanged: (val) => settings.setCcToggleHeight(val)
                    }

                    SliderSetting {
                        label: "Toggle icon size"
                        value: settings.ccToggleIconSize
                        from: 16; to: 32
                        onChanged: (val) => settings.setCcToggleIconSize(val)
                    }

                    SliderSetting {
                        label: "Slider height"
                        value: settings.ccSliderHeight
                        from: 30; to: 60
                        onChanged: (val) => settings.setCcSliderHeight(val)
                    }

                    SliderSetting {
                        label: "Handle size"
                        value: settings.ccSliderHandleSize
                        from: 12; to: 30
                        onChanged: (val) => settings.setCcSliderHandleSize(val)
                    }
                }
            }

            SettingsCard {
                title: "Animations"
                description: "Open/close animation behavior"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    OptionSetting {
                        label: "Animation type"
                        options: ["slide", "fade", "scale", "bounce", "none"]
                        value: settings.ccAnimation
                        onChanged: (val) => settings.setCcAnimation(val)
                    }

                    SliderSetting {
                        label: "Duration"
                        value: settings.ccAnimationDuration
                        from: 100; to: 500
                        suffix: "ms"
                        onChanged: (val) => settings.setCcAnimationDuration(val)
                    }

                    SliderSetting {
                        label: "Overshoot"
                        value: Math.round(settings.ccAnimationOvershoot * 100)
                        from: 100; to: 150
                        suffix: "%"
                        onChanged: (val) => settings.setCcAnimationOvershoot(val / 100)
                    }
                }
            }
        }
    }

    Component {
        id: launcherSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Launcher"; icon: "󰈹" }

            SettingsCard {
                title: "Appearance"
                description: "Panel styling"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Corner radius"
                        value: settings.launcherRadius
                        from: 0; to: 32
                        onChanged: (val) => settings.setLauncherRadius(val)
                    }

                    SliderSetting {
                        label: "Border width"
                        value: settings.launcherBorderWidth
                        from: 0; to: 4
                        onChanged: (val) => settings.setLauncherBorderWidth(val)
                    }
                }
            }

            SettingsCard {
                title: "Behavior"
                description: "Size and grid layout"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Width"
                        value: settings.launcherWidth
                        from: 600; to: 1200
                        onChanged: (val) => settings.setLauncherWidth(val)
                    }

                    SliderSetting {
                        label: "Height"
                        value: settings.launcherHeight
                        from: 400; to: 900
                        onChanged: (val) => settings.setLauncherHeight(val)
                    }

                    SliderSetting {
                        label: "Columns"
                        value: settings.launcherColumns
                        from: 4; to: 10
                        onChanged: (val) => settings.setLauncherColumns(val)
                    }

                    SliderSetting {
                        label: "Icon size"
                        value: settings.launcherIconSize
                        from: 32; to: 72
                        onChanged: (val) => settings.setLauncherIconSize(val)
                    }
                }
            }

            SettingsCard {
                title: "Animations"
                description: "No animation settings yet"
            }
        }
    }

    Component {
        id: dockSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Dock"; icon: "󰘔" }

            SettingsCard {
                title: "Appearance"
                description: "Dock styling"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Corner radius"
                        value: settings.dockRadius
                        from: 0; to: 24
                        onChanged: (val) => settings.setDockRadius(val)
                    }

                    SliderSetting {
                        label: "Border width"
                        value: settings.dockBorderWidth
                        from: 0; to: 4
                        onChanged: (val) => settings.setDockBorderWidth(val)
                    }
                }
            }

            SettingsCard {
                title: "Behavior"
                description: "Reveal and layout"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Height"
                        value: settings.dockHeight
                        from: 50; to: 100
                        onChanged: (val) => settings.setDockHeight(val)
                    }

                    SliderSetting {
                        label: "Bottom margin"
                        value: settings.dockMarginBottom
                        from: 0; to: 24
                        onChanged: (val) => settings.setDockMarginBottom(val)
                    }

                    SliderSetting {
                        label: "Reveal height"
                        value: settings.dockRevealHeight
                        from: 1; to: 12
                        onChanged: (val) => settings.setDockRevealHeight(val)
                    }

                    ToggleSetting {
                        label: "Auto hide"
                        value: settings.dockAutoHide
                        onChanged: (val) => settings.setDockAutoHide(val)
                    }
                }
            }

            SettingsCard {
                title: "Animations"
                description: "No animation settings yet"
            }
        }
    }

    Component {
        id: settingsPanelSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Settings Panel"; icon: "󰍹" }

            SettingsCard {
                title: "Appearance"
                description: "Panel styling"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Corner radius"
                        value: settings.settingsPanelRadius
                        from: 0; to: 32
                        onChanged: (val) => settings.setSettingsPanelRadius(val)
                    }

                    SliderSetting {
                        label: "Border width"
                        value: settings.settingsPanelBorderWidth
                        from: 0; to: 4
                        onChanged: (val) => settings.setSettingsPanelBorderWidth(val)
                    }
                }
            }

            SettingsCard {
                title: "Behavior"
                description: "No behavior settings yet"
            }

            SettingsCard {
                title: "Animations"
                description: "No animation settings yet"
            }
        }
    }

    Component {
        id: quickSettingsSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Quick Settings"; icon: "󰖩" }

            SettingsCard {
                title: "Appearance"
                description: "No appearance settings yet"
            }

            SettingsCard {
                title: "Behavior"
                description: "No behavior settings yet"
            }

            SettingsCard {
                title: "Animations"
                description: "No animation settings yet"
            }
        }
    }

    Component {
        id: notificationsSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Notifications"; icon: "󰂚" }

            SettingsCard {
                title: "Appearance"
                description: "No appearance settings yet"
            }

            SettingsCard {
                title: "Behavior"
                description: "No behavior settings yet"
            }

            SettingsCard {
                title: "Animations"
                description: "No animation settings yet"
            }
        }
    }

    Component {
        id: calendarSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Calendar"; icon: "󰃭" }

            SettingsCard {
                title: "Appearance"
                description: "No appearance settings yet"
            }

            SettingsCard {
                title: "Behavior"
                description: "No behavior settings yet"
            }

            SettingsCard {
                title: "Animations"
                description: "No animation settings yet"
            }
        }
    }

    Component {
        id: musicSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Music Player"; icon: "󰎈" }

            SettingsCard {
                title: "Appearance"
                description: "No appearance settings yet"
            }

            SettingsCard {
                title: "Behavior"
                description: "No behavior settings yet"
            }

            SettingsCard {
                title: "Animations"
                description: "No animation settings yet"
            }
        }
    }

    Component {
        id: systemMonitorSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "System Monitor"; icon: "󰍛" }

            SettingsCard {
                title: "Appearance"
                description: "No appearance settings yet"
            }

            SettingsCard {
                title: "Behavior"
                description: "No behavior settings yet"
            }

            SettingsCard {
                title: "Animations"
                description: "No animation settings yet"
            }
        }
    }

    Component {
        id: themeSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Theme"; icon: "󰌁" }

            Loader { Layout.fillWidth: true; sourceComponent: colorsSection }
            Loader { Layout.fillWidth: true; sourceComponent: typographySection }
        }
    }

    Component {
        id: appearanceSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Appearance"; icon: "󰏘" }

            SettingsCard {
                title: "Global Shape"
                description: "Default corner sizes used across the shell"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Large (panels)"
                        value: settings.radiusLarge
                        from: 0; to: 32
                        onChanged: (val) => settings.setRadiusLarge(val)
                    }

                    SliderSetting {
                        label: "Medium (cards)"
                        value: settings.radiusMedium
                        from: 0; to: 24
                        onChanged: (val) => settings.setRadiusMedium(val)
                    }

                    SliderSetting {
                        label: "Small (buttons)"
                        value: settings.radiusSmall
                        from: 0; to: 16
                        onChanged: (val) => settings.setRadiusSmall(val)
                    }
                }
            }

            SettingsCard {
                title: "Global Borders"
                description: "Default border styling for panels and cards"

                SliderSetting {
                    label: "Border width"
                    value: settings.borderWidth
                    from: 0; to: 4
                    onChanged: (val) => settings.setBorderWidth(val)
                }
            }

            SettingsCard {
                title: "Bar Appearance"
                description: "Top bar styling"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Background opacity"
                        value: Math.round(settings.barOpacity * 100)
                        from: 50; to: 100
                        suffix: "%"
                        onChanged: (val) => settings.setBarOpacity(val / 100)
                    }

                    SliderSetting {
                        label: "Corner radius"
                        value: settings.barRadius
                        from: 0; to: 24
                        onChanged: (val) => settings.setBarRadius(val)
                    }

                    SliderSetting {
                        label: "Border width"
                        value: settings.barBorderWidth
                        from: 0; to: 4
                        onChanged: (val) => settings.setBarBorderWidth(val)
                    }
                }
            }

            SettingsCard {
                title: "Control Center Appearance"
                description: "Panel and card styling"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Panel radius"
                        value: settings.ccPanelRadius
                        from: 0; to: 32
                        onChanged: (val) => settings.setCcPanelRadius(val)
                    }

                    SliderSetting {
                        label: "Panel border"
                        value: settings.ccPanelBorderWidth
                        from: 0; to: 4
                        onChanged: (val) => settings.setCcPanelBorderWidth(val)
                    }

                    SliderSetting {
                        label: "Card radius"
                        value: settings.ccCardRadius
                        from: 0; to: 24
                        onChanged: (val) => settings.setCcCardRadius(val)
                    }
                }
            }

            SettingsCard {
                title: "Launcher Appearance"
                description: "Launcher styling"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Corner radius"
                        value: settings.launcherRadius
                        from: 0; to: 32
                        onChanged: (val) => settings.setLauncherRadius(val)
                    }

                    SliderSetting {
                        label: "Border width"
                        value: settings.launcherBorderWidth
                        from: 0; to: 4
                        onChanged: (val) => settings.setLauncherBorderWidth(val)
                    }
                }
            }

            SettingsCard {
                title: "Settings Panel Appearance"
                description: "Settings panel styling"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Corner radius"
                        value: settings.settingsPanelRadius
                        from: 0; to: 32
                        onChanged: (val) => settings.setSettingsPanelRadius(val)
                    }

                    SliderSetting {
                        label: "Border width"
                        value: settings.settingsPanelBorderWidth
                        from: 0; to: 4
                        onChanged: (val) => settings.setSettingsPanelBorderWidth(val)
                    }
                }
            }

            SettingsCard {
                title: "Dock Appearance"
                description: "Dock styling"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Corner radius"
                        value: settings.dockRadius
                        from: 0; to: 24
                        onChanged: (val) => settings.setDockRadius(val)
                    }

                    SliderSetting {
                        label: "Border width"
                        value: settings.dockBorderWidth
                        from: 0; to: 4
                        onChanged: (val) => settings.setDockBorderWidth(val)
                    }
                }
            }
        }
    }

    Component {
        id: colorsSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Colors"; icon: "󰌁" }

            SettingsCard {
                title: "Presets (Base16)"
                description: "Apply a Base16 color scheme to all theme slots"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        ComboBox {
                            id: base16Combo
                            Layout.fillWidth: true
                            model: settingsPanel.base16Schemes
                            textRole: "name"
                        }

                        Rectangle {
                            width: 120
                            height: 32
                            radius: settings.radiusSmall
                            color: applyPresetMouse.containsMouse ? settings.colorSurface : settings.colorBackgroundAlt
                            border.width: 1
                            border.color: settings.colorAccent

                            Text {
                                anchors.centerIn: parent
                                text: "Apply"
                                font.family: settings.fontFamily
                                font.pixelSize: 12
                                color: settings.colorAccent
                            }

                            MouseArea {
                                id: applyPresetMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    var scheme = settingsPanel.base16Schemes[base16Combo.currentIndex]
                                    if (scheme) settingsPanel.applyBase16(scheme)
                                }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Rectangle {
                            width: 28
                            height: 28
                            radius: 6
                            color: settingsPanel.base16Schemes[base16Combo.currentIndex].base00
                            border.width: 1
                            border.color: settingsPanel.base16Schemes[base16Combo.currentIndex].base05
                        }

                        Repeater {
                            model: [
                                settingsPanel.base16Schemes[base16Combo.currentIndex].base08,
                                settingsPanel.base16Schemes[base16Combo.currentIndex].base09,
                                settingsPanel.base16Schemes[base16Combo.currentIndex].base0A,
                                settingsPanel.base16Schemes[base16Combo.currentIndex].base0B,
                                settingsPanel.base16Schemes[base16Combo.currentIndex].base0C,
                                settingsPanel.base16Schemes[base16Combo.currentIndex].base0D,
                                settingsPanel.base16Schemes[base16Combo.currentIndex].base0E,
                                settingsPanel.base16Schemes[base16Combo.currentIndex].base0F
                            ]

                            Rectangle {
                                width: 14
                                height: 14
                                radius: 3
                                color: modelData
                                border.width: 1
                                border.color: settings.colorBorder
                            }
                        }
                    }
                }
            }

            SettingsCard {
                title: "Base Colors"
                description: "Background and surface colors"

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 12
                    columnSpacing: 12

                    ColorSetting {
                        label: "Background"
                        color: settings.colorBackground
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorBackground(col)
                    }

                    ColorSetting {
                        label: "Background Alt"
                        color: settings.colorBackgroundAlt
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorBackgroundAlt(col)
                    }

                    ColorSetting {
                        label: "Surface"
                        color: settings.colorSurface
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorSurface(col)
                    }

                    ColorSetting {
                        label: "Border"
                        color: settings.colorBorder
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorBorder(col)
                    }
                }
            }

            SettingsCard {
                title: "Text Colors"
                description: "Text and label colors"

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 12
                    columnSpacing: 12

                    ColorSetting {
                        label: "Primary"
                        color: settings.colorText
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorText(col)
                    }

                    ColorSetting {
                        label: "Dimmed"
                        color: settings.colorTextDim
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorTextDim(col)
                    }

                    ColorSetting {
                        label: "Muted"
                        color: settings.colorTextMuted
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorTextMuted(col)
                    }
                }
            }

            SettingsCard {
                title: "Accent Colors"
                description: "Primary accent and highlight colors"

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 12
                    columnSpacing: 12

                    ColorSetting {
                        label: "Accent"
                        color: settings.colorAccent
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorAccent(col)
                    }

                    ColorSetting {
                        label: "Accent Alt"
                        color: settings.colorAccentAlt
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorAccentAlt(col)
                    }
                }
            }

            SettingsCard {
                title: "Semantic Colors"
                description: "Status and feedback colors"

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 12
                    columnSpacing: 12

                    ColorSetting {
                        label: "Success"
                        color: settings.colorSuccess
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorSuccess(col)
                    }

                    ColorSetting {
                        label: "Warning"
                        color: settings.colorWarning
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorWarning(col)
                    }

                    ColorSetting {
                        label: "Error"
                        color: settings.colorError
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorError(col)
                    }

                    ColorSetting {
                        label: "Info"
                        color: settings.colorInfo
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorInfo(col)
                    }
                }
            }

            SettingsCard {
                title: "Extra Colors"
                description: "Additional accent colors"

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    rowSpacing: 12
                    columnSpacing: 12

                    ColorSetting {
                        label: "Purple"
                        color: settings.colorPurple
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorPurple(col)
                    }

                    ColorSetting {
                        label: "Teal"
                        color: settings.colorTeal
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorTeal(col)
                    }

                    ColorSetting {
                        label: "Pink"
                        color: settings.colorPink
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorPink(col)
                    }

                    ColorSetting {
                        label: "Peach"
                        color: settings.colorPeach
                        palette: settingsPanel.colorPalette
                        onChanged: (col) => settings.setColorPeach(col)
                    }
                }
            }
        }
    }

    Component {
        id: layoutSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Layout"; icon: "󰕰" }

            SettingsCard {
                title: "Control Center"
                description: "Control center panel layout"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    OptionSetting {
                        label: "Position"
                        options: ["top-left", "top-center", "top-right"]
                        value: settings.ccPosition
                        onChanged: (val) => settings.setCcPosition(val)
                    }

                    SliderSetting {
                        label: "Panel width"
                        value: settings.ccWidth
                        from: 300; to: 500
                        onChanged: (val) => settings.setCcWidth(val)
                    }

                    SliderSetting {
                        label: "Top margin"
                        value: settings.ccMarginTop
                        from: 0; to: 100
                        onChanged: (val) => settings.setCcMarginTop(val)
                    }

                    SliderSetting {
                        label: "Side margin"
                        value: settings.ccMarginSide
                        from: 0; to: 50
                        onChanged: (val) => settings.setCcMarginSide(val)
                    }

                    SliderSetting {
                        label: "Padding"
                        value: settings.ccPadding
                        from: 8; to: 32
                        onChanged: (val) => settings.setCcPadding(val)
                    }

                    SliderSetting {
                        label: "Card spacing"
                        value: settings.ccCardSpacing
                        from: 4; to: 24
                        onChanged: (val) => settings.setCcCardSpacing(val)
                    }

                    SliderSetting {
                        label: "Toggle columns"
                        value: settings.ccToggleColumns
                        from: 2; to: 4
                        onChanged: (val) => settings.setCcToggleColumns(val)
                    }
                }
            }

            SettingsCard {
                title: "Bar"
                description: "Top bar layout settings"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Height"
                        value: settings.barHeight
                        from: 30; to: 60
                        onChanged: (val) => settings.setBarHeight(val)
                    }

                    SliderSetting {
                        label: "Top margin"
                        value: settings.barMarginTop
                        from: 0; to: 20
                        onChanged: (val) => settings.setBarMarginTop(val)
                    }

                    SliderSetting {
                        label: "Side margin"
                        value: settings.barMarginSide
                        from: 0; to: 30
                        onChanged: (val) => settings.setBarMarginSide(val)
                    }
                }
            }

            SettingsCard {
                title: "Dock"
                description: "Dock layout and behavior"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Height"
                        value: settings.dockHeight
                        from: 50; to: 100
                        onChanged: (val) => settings.setDockHeight(val)
                    }

                    SliderSetting {
                        label: "Bottom margin"
                        value: settings.dockMarginBottom
                        from: 0; to: 24
                        onChanged: (val) => settings.setDockMarginBottom(val)
                    }

                    SliderSetting {
                        label: "Reveal height"
                        value: settings.dockRevealHeight
                        from: 1; to: 12
                        onChanged: (val) => settings.setDockRevealHeight(val)
                    }

                    ToggleSetting {
                        label: "Auto hide"
                        value: settings.dockAutoHide
                        onChanged: (val) => settings.setDockAutoHide(val)
                    }
                }
            }

            SettingsCard {
                title: "Launcher"
                description: "Application launcher layout"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Width"
                        value: settings.launcherWidth
                        from: 600; to: 1200
                        onChanged: (val) => settings.setLauncherWidth(val)
                    }

                    SliderSetting {
                        label: "Height"
                        value: settings.launcherHeight
                        from: 400; to: 900
                        onChanged: (val) => settings.setLauncherHeight(val)
                    }

                    SliderSetting {
                        label: "Icon size"
                        value: settings.launcherIconSize
                        from: 32; to: 72
                        onChanged: (val) => settings.setLauncherIconSize(val)
                    }
                }
            }
        }
    }

    Component {
        id: animationsSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Animations"; icon: "󰑮" }

            SettingsCard {
                title: "Control Center Animation"
                description: "How the control center opens and closes"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    OptionSetting {
                        label: "Animation type"
                        options: ["slide", "fade", "scale", "bounce", "none"]
                        value: settings.ccAnimation
                        onChanged: (val) => settings.setCcAnimation(val)
                    }

                    SliderSetting {
                        label: "Duration (ms)"
                        value: settings.ccAnimationDuration
                        from: 100; to: 500
                        suffix: "ms"
                        onChanged: (val) => settings.setCcAnimationDuration(val)
                    }

                    SliderSetting {
                        label: "Overshoot (bounce)"
                        value: Math.round(settings.ccAnimationOvershoot * 100)
                        from: 100; to: 150
                        suffix: "%"
                        onChanged: (val) => settings.setCcAnimationOvershoot(val / 100)
                    }
                }
            }

            SettingsCard {
                title: "Toggle Sizes"
                description: "Quick toggle button dimensions"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Toggle height"
                        value: settings.ccToggleHeight
                        from: 50; to: 100
                        onChanged: (val) => settings.setCcToggleHeight(val)
                    }

                    SliderSetting {
                        label: "Toggle icon size"
                        value: settings.ccToggleIconSize
                        from: 16; to: 32
                        onChanged: (val) => settings.setCcToggleIconSize(val)
                    }
                }
            }

            SettingsCard {
                title: "Slider Sizes"
                description: "Volume and brightness slider dimensions"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Slider height"
                        value: settings.ccSliderHeight
                        from: 30; to: 60
                        onChanged: (val) => settings.setCcSliderHeight(val)
                    }

                    SliderSetting {
                        label: "Handle size"
                        value: settings.ccSliderHandleSize
                        from: 12; to: 30
                        onChanged: (val) => settings.setCcSliderHandleSize(val)
                    }
                }
            }
        }
    }

    Component {
        id: typographySection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "Typography"; icon: "󰛖" }

            SettingsCard {
                title: "Font Family"
                description: "Main font used throughout the shell"

                TextInputSetting {
                    label: "Font name"
                    value: settings.fontFamily
                    onChanged: (val) => settings.setFontFamily(val)
                }
            }

            SettingsCard {
                title: "Font Sizes"
                description: "Text size hierarchy"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    SliderSetting {
                        label: "Header"
                        value: settings.fontSizeHeader
                        from: 10; to: 24
                        suffix: "px"
                        onChanged: (val) => settings.setFontSizeHeader(val)
                    }

                    SliderSetting {
                        label: "Label"
                        value: settings.fontSizeLabel
                        from: 8; to: 18
                        suffix: "px"
                        onChanged: (val) => settings.setFontSizeLabel(val)
                    }

                    SliderSetting {
                        label: "Value"
                        value: settings.fontSizeValue
                        from: 16; to: 36
                        suffix: "px"
                        onChanged: (val) => settings.setFontSizeValue(val)
                    }

                    SliderSetting {
                        label: "Icon"
                        value: settings.fontSizeIcon
                        from: 12; to: 28
                        suffix: "px"
                        onChanged: (val) => settings.setFontSizeIcon(val)
                    }
                }
            }
        }
    }

    Component {
        id: aboutSection

        ColumnLayout {
            spacing: 20

            SectionHeader { title: "About"; icon: "󰋼" }

            SettingsCard {
                title: "Quickshell Configuration"
                description: "Custom shell built with Quickshell"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: "Version: 1.0.0"
                        font.family: settings.fontFamily
                        font.pixelSize: 12
                        color: settings.colorTextDim
                    }

                    Text {
                        text: "Theme: Catppuccin Mocha"
                        font.family: settings.fontFamily
                        font.pixelSize: 12
                        color: settings.colorTextDim
                    }

                    Text {
                        text: "Built with Quickshell + QML"
                        font.family: settings.fontFamily
                        font.pixelSize: 12
                        color: settings.colorTextDim
                    }
                }
            }

            SettingsCard {
                title: "Keyboard Shortcuts"
                description: "Available keybindings"

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    ShortcutRow { keys: "Super + A"; action: "Toggle Control Center" }
                    ShortcutRow { keys: "Super + R"; action: "Open App Launcher" }
                    ShortcutRow { keys: "Super + Ctrl + R"; action: "Reload Quickshell" }
                    ShortcutRow { keys: "Super + Shift + R"; action: "Reload Hyprland" }
                }
            }
        }
    }

    // ========================================
    // REUSABLE UI COMPONENTS
    // ========================================

    component SectionHeader: RowLayout {
        property string title: "Section"
        property string icon: "󰒓"

        Layout.fillWidth: true
        Layout.bottomMargin: 8
        spacing: 10

        Text {
            text: icon
            font.family: settings.fontFamily
            font.pixelSize: 24
            color: settings.colorAccent
        }

        Text {
            text: title
            font.family: settings.fontFamily
            font.pixelSize: 20
            font.bold: true
            color: settings.colorText
        }
    }

    component SettingsCard: Rectangle {
        property string title: "Card"
        property string description: ""
        default property alias content: cardContent.data

        Layout.fillWidth: true
        implicitHeight: cardColumn.implicitHeight + 24
        color: settings.colorBackgroundAlt
        radius: settings.radiusMedium

        ColumnLayout {
            id: cardColumn
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            ColumnLayout {
                spacing: 2

                Text {
                    text: title
                    font.family: settings.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: settings.colorText
                }

                Text {
                    text: description
                    font.family: settings.fontFamily
                    font.pixelSize: 11
                    color: settings.colorTextMuted
                    visible: description !== ""
                }
            }

            ColumnLayout {
                id: cardContent
                Layout.fillWidth: true
                spacing: 8
            }
        }
    }

    component SliderSetting: RowLayout {
        property string label: "Setting"
        property int value: 50
        property int from: 0
        property int to: 100
        property string suffix: ""

        signal changed(int val)

        Layout.fillWidth: true
        spacing: 12

        Text {
            text: label
            font.family: settings.fontFamily
            font.pixelSize: 12
            color: settings.colorTextDim
            Layout.preferredWidth: 120
        }

        Item {
            Layout.fillWidth: true
            height: 24

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 6
                radius: 3
                color: settings.colorSurface

                Rectangle {
                    width: ((value - from) / (to - from)) * parent.width
                    height: parent.height
                    radius: parent.radius
                    color: settings.colorAccent
                }
            }

            Rectangle {
                x: ((value - from) / (to - from)) * (parent.width - width)
                anchors.verticalCenter: parent.verticalCenter
                width: 16
                height: 16
                radius: 8
                color: settings.colorAccent
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onPositionChanged: (mouse) => {
                    if (pressed) {
                        var ratio = Math.max(0, Math.min(1, mouse.x / width))
                        var newVal = Math.round(from + ratio * (to - from))
                        if (newVal !== value) changed(newVal)
                    }
                }

                onClicked: (mouse) => {
                    var ratio = Math.max(0, Math.min(1, mouse.x / width))
                    var newVal = Math.round(from + ratio * (to - from))
                    changed(newVal)
                }
            }
        }

        Text {
            text: value + suffix
            font.family: settings.fontFamily
            font.pixelSize: 12
            font.bold: true
            color: settings.colorText
            horizontalAlignment: Text.AlignRight
            Layout.preferredWidth: 50
        }
    }

    component ColorSetting: RowLayout {
        id: colorSetting
        property string label: "Color"
        property color color: "#ffffff"
        property var palette: []
        property real hue: 0.0
        property real saturation: 1.0
        property real value: 1.0

        signal changed(color col)

        Layout.fillWidth: true
        spacing: 8

        onColorChanged: {
            var hsv = rgbToHsv(colorSetting.color.r, colorSetting.color.g, colorSetting.color.b)
            hue = hsv.h
            saturation = hsv.s
            value = hsv.v
        }

        Component.onCompleted: {
            var hsv = rgbToHsv(colorSetting.color.r, colorSetting.color.g, colorSetting.color.b)
            hue = hsv.h
            saturation = hsv.s
            value = hsv.v
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    width: 28
                    height: 28
                    radius: 6
                    color: colorSetting.color
                    border.width: 2
                    border.color: settings.colorBorder

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        // TODO: Open color picker
                    }
                }

                Text {
                    text: label
                    font.family: settings.fontFamily
                    font.pixelSize: 12
                    color: settings.colorTextDim
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 80
                    height: 28
                    radius: 4
                    color: settings.colorSurface

                    TextInput {
                        anchors.fill: parent
                        anchors.margins: 6
                        text: colorToHex(colorSetting.color)
                        font.family: settings.fontFamily
                        font.pixelSize: 11
                        color: settings.colorText
                        selectByMouse: true

                        onEditingFinished: {
                            if (text.match(/^#[0-9A-Fa-f]{6}$/)) {
                                changed(text.toUpperCase())
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: svPicker
                Layout.fillWidth: true
                height: 140
                radius: 8
                border.width: 1
                border.color: settings.colorBorder

                Rectangle {
                    id: svBase
                    anchors.fill: parent
                    radius: parent.radius
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.00; color: "#ffffff" }
                        GradientStop { position: 1.00; color: hsvToRgbColor(hue, 1, 1) }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    gradient: Gradient {
                        orientation: Gradient.Vertical
                        GradientStop { position: 0.00; color: Qt.rgba(0, 0, 0, 0) }
                        GradientStop { position: 1.00; color: Qt.rgba(0, 0, 0, 1) }
                    }
                }

                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    border.width: 2
                    border.color: "#ffffff"
                    color: "transparent"
                    x: saturation * (parent.width - width)
                    y: (1 - value) * (parent.height - height)
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onPositionChanged: (mouse) => {
                        if (pressed) {
                            updateSV(mouse.x, mouse.y, svPicker.width, svPicker.height)
                        }
                    }
                    onClicked: (mouse) => updateSV(mouse.x, mouse.y, svPicker.width, svPicker.height)
                }
            }

            Rectangle {
                id: hueBar
                Layout.fillWidth: true
                height: 12
                radius: 6
                border.width: 1
                border.color: settings.colorBorder

                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.00; color: "#ff0000" }
                    GradientStop { position: 0.17; color: "#ffff00" }
                    GradientStop { position: 0.33; color: "#00ff00" }
                    GradientStop { position: 0.50; color: "#00ffff" }
                    GradientStop { position: 0.67; color: "#0000ff" }
                    GradientStop { position: 0.83; color: "#ff00ff" }
                    GradientStop { position: 1.00; color: "#ff0000" }
                }

                Rectangle {
                    width: 10
                    height: 20
                    radius: 4
                    y: -4
                    x: hue * (parent.width - width)
                    color: settings.colorBackground
                    border.width: 1
                    border.color: settings.colorBorder
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onPositionChanged: (mouse) => {
                        if (pressed) updateHue(mouse.x, hueBar.width)
                    }
                    onClicked: (mouse) => updateHue(mouse.x, hueBar.width)
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Repeater {
                    model: palette

                    Rectangle {
                        width: 20
                        height: 20
                        radius: 4
                        color: modelData
                        border.width: 1
                        border.color: settings.colorBorder

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: changed(modelData.toUpperCase())
                        }
                    }
                }
            }
        }

        function clamp01(value) {
            return Math.max(0, Math.min(1, value))
        }

        function hsvToRgb(h, s, v) {
            var i = Math.floor(h * 6)
            var f = h * 6 - i
            var p = v * (1 - s)
            var q = v * (1 - f * s)
            var t = v * (1 - (1 - f) * s)
            var r, g, b

            switch (i % 6) {
                case 0: r = v; g = t; b = p; break
                case 1: r = q; g = v; b = p; break
                case 2: r = p; g = v; b = t; break
                case 3: r = p; g = q; b = v; break
                case 4: r = t; g = p; b = v; break
                case 5: r = v; g = p; b = q; break
            }

            return { r: r, g: g, b: b }
        }

        function rgbToHsv(r, g, b) {
            var max = Math.max(r, g, b)
            var min = Math.min(r, g, b)
            var d = max - min
            var h = 0
            var s = max === 0 ? 0 : d / max
            var v = max

            if (d !== 0) {
                if (max === r) {
                    h = (g - b) / d + (g < b ? 6 : 0)
                } else if (max === g) {
                    h = (b - r) / d + 2
                } else {
                    h = (r - g) / d + 4
                }
                h /= 6
            }

            return { h: h, s: s, v: v }
        }

        function hsvToRgbColor(h, s, v) {
            var rgb = hsvToRgb(h, s, v)
            return Qt.rgba(rgb.r, rgb.g, rgb.b, 1)
        }

        function rgbToHex(rgb) {
            function toHex(value) {
                var hex = Math.round(clamp01(value) * 255).toString(16)
                return hex.length === 1 ? "0" + hex : hex
            }

            return ("#" + toHex(rgb.r) + toHex(rgb.g) + toHex(rgb.b)).toUpperCase()
        }

        function colorToHex(c) {
            return rgbToHex({ r: c.r, g: c.g, b: c.b })
        }

        function updateHue(xPos, barWidth) {
            hue = clamp01(xPos / Math.max(1, barWidth))
            var rgb = hsvToRgb(hue, saturation, value)
            changed(rgbToHex(rgb))
        }

        function updateSV(xPos, yPos, areaWidth, areaHeight) {
            saturation = clamp01(xPos / Math.max(1, areaWidth))
            value = 1 - clamp01(yPos / Math.max(1, areaHeight))
            var rgb = hsvToRgb(hue, saturation, value)
            changed(rgbToHex(rgb))
        }
    }

    component OptionSetting: RowLayout {
        property string label: "Option"
        property var options: []
        property string value: ""

        signal changed(string val)

        Layout.fillWidth: true
        spacing: 12

        Text {
            text: label
            font.family: settings.fontFamily
            font.pixelSize: 12
            color: settings.colorTextDim
            Layout.preferredWidth: 120
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Repeater {
                model: options

                Rectangle {
                    Layout.fillWidth: true
                    height: 28
                    radius: settings.radiusSmall
                    color: value === modelData ?
                           Qt.rgba(settings.colorAccent.r, settings.colorAccent.g, settings.colorAccent.b, 0.3) :
                           settings.colorSurface
                    border.width: value === modelData ? 1 : 0
                    border.color: settings.colorAccent

                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.family: settings.fontFamily
                        font.pixelSize: 10
                        color: value === modelData ? settings.colorAccent : settings.colorTextDim
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: changed(modelData)
                    }
                }
            }
        }
    }

    component TextInputSetting: RowLayout {
        property string label: "Setting"
        property string value: ""

        signal changed(string val)

        Layout.fillWidth: true
        spacing: 12

        Text {
            text: label
            font.family: settings.fontFamily
            font.pixelSize: 12
            color: settings.colorTextDim
            Layout.preferredWidth: 120
        }

        Rectangle {
            Layout.fillWidth: true
            height: 32
            radius: settings.radiusSmall
            color: settings.colorSurface

            TextInput {
                anchors.fill: parent
                anchors.margins: 8
                verticalAlignment: TextInput.AlignVCenter
                text: value
                font.family: settings.fontFamily
                font.pixelSize: 12
                color: settings.colorText
                selectByMouse: true
                activeFocusOnPress: true
                clip: true

                onEditingFinished: changed(text)
            }
        }
    }

    component FormatPresets: RowLayout {
        property var presets: []

        signal selected(string val)

        Layout.fillWidth: true
        spacing: 6
        Layout.leftMargin: 132

        Repeater {
            model: presets

            Rectangle {
                height: 24
                width: presetText.implicitWidth + 16
                radius: settings.radiusSmall
                color: presetMouse.containsMouse ? settings.colorSurface : settings.colorBackgroundAlt
                border.width: 1
                border.color: presetMouse.containsMouse ? settings.colorAccent : settings.colorBorder

                Behavior on color { ColorAnimation { duration: 100 } }
                Behavior on border.color { ColorAnimation { duration: 100 } }

                Text {
                    id: presetText
                    anchors.centerIn: parent
                    text: modelData.label
                    font.family: settings.fontFamily
                    font.pixelSize: 10
                    color: presetMouse.containsMouse ? settings.colorAccent : settings.colorTextDim
                }

                MouseArea {
                    id: presetMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: selected(modelData.value)
                }
            }
        }
    }

    component ToggleSetting: RowLayout {
        property string label: "Toggle"
        property bool value: false

        signal changed(bool val)

        Layout.fillWidth: true
        spacing: 12

        Text {
            text: label
            font.family: settings.fontFamily
            font.pixelSize: 12
            color: settings.colorTextDim
            Layout.preferredWidth: 120
        }

        Item { Layout.fillWidth: true }

        Switch {
            checked: value
            onToggled: changed(checked)
        }
    }

    component ShortcutRow: RowLayout {
        property string keys: "Key"
        property string action: "Action"

        Layout.fillWidth: true
        spacing: 12

        Rectangle {
            width: keyText.implicitWidth + 16
            height: 24
            radius: 4
            color: settings.colorSurface

            Text {
                id: keyText
                anchors.centerIn: parent
                text: keys
                font.family: settings.fontFamily
                font.pixelSize: 11
                font.bold: true
                color: settings.colorAccent
            }
        }

        Text {
            text: action
            font.family: settings.fontFamily
            font.pixelSize: 12
            color: settings.colorTextDim
            Layout.fillWidth: true
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

WlrLayershell {
    id: launcher

    property var settings: null
    property var appExecSet: ({})

    layer: WlrLayer.Overlay
    exclusiveZone: 0
    namespace: "launcher"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    color: "transparent"
    visible: launcherVisible
    
    property bool launcherVisible: false
    property var appsAll: []
    property string searchText: ""
    property string sortMode: "A-Z"
    property string viewMode: "Icon"

    ListModel {
        id: appsModel
    }

    function addApp(app) {
        var execKey = app.exec.split(" ")[0]
        if (appExecSet[execKey]) return
        appExecSet[execKey] = true
        appsAll.push(app)
        rebuildModel()
    }

    function rebuildModel() {
        var list = appsAll.slice(0)
        var searchLower = (searchText || "").toLowerCase()
        if (sortMode === "A-Z") {
            list.sort(function(a, b) { return a.name.localeCompare(b.name) })
        } else if (sortMode === "Z-A") {
            list.sort(function(a, b) { return b.name.localeCompare(a.name) })
        } else if (sortMode === "Modified") {
            list.sort(function(a, b) { return (b.mtime || 0) - (a.mtime || 0) })
        } else if (sortMode === "Modified (Oldest)") {
            list.sort(function(a, b) { return (a.mtime || 0) - (b.mtime || 0) })
        }

        appsModel.clear()
        for (var i = 0; i < list.length; i++) {
            var app = list[i]
            if (searchLower) {
                var name = (app.name || "").toLowerCase()
                var keywords = (app.keywords || "").toLowerCase()
                if (!name.includes(searchLower) && !keywords.includes(searchLower)) {
                    continue
                }
            }
            appsModel.append(app)
        }
    }

    function nerdIconForDesktop(entry) {
        var name = (entry.iconName || entry.name || "").toLowerCase()
        var cats = (entry.categories || "").toLowerCase()
        var execName = (entry.exec || "").split(" ")[0].toLowerCase()
        var haystack = name + " " + cats + " " + execName

        if (haystack.includes("firefox")) return "󰈹"
        if (haystack.includes("chrome") || haystack.includes("chromium") || haystack.includes("brave") || haystack.includes("browser")) return "󰊯"
        if (haystack.includes("edge")) return "󰇩"
        if (haystack.includes("opera")) return "󰀫"
        if (haystack.includes("terminal") || haystack.includes("alacritty") || haystack.includes("kitty") || haystack.includes("konsole")) return "󰆍"
        if (haystack.includes("nautilus") || haystack.includes("thunar") || haystack.includes("dolphin") || haystack.includes("files")) return "󰉋"
        if (haystack.includes("code") || haystack.includes("codium") || haystack.includes("vscode")) return "󰨞"
        if (haystack.includes("discord")) return "󰙯"
        if (haystack.includes("telegram") || haystack.includes("element")) return "󰄫"
        if (haystack.includes("slack")) return "󰒱"
        if (haystack.includes("signal")) return "󰍡"
        if (haystack.includes("thunderbird") || haystack.includes("mail")) return "󰇰"
        if (haystack.includes("spotify") || haystack.includes("music") || cats.includes("audiovideo")) return "󰎈"
        if (haystack.includes("vlc")) return "󰕼"
        if (haystack.includes("obs")) return "󰑋"
        if (haystack.includes("kdenlive")) return "󰈰"
        if (haystack.includes("gimp") || haystack.includes("krita") || cats.includes("graphics")) return "󰏘"
        if (haystack.includes("inkscape")) return "󰜡"
        if (haystack.includes("blender")) return "󰂫"
        if (haystack.includes("libreoffice") || cats.includes("office")) return "󰈙"
        if (haystack.includes("gitkraken") || haystack.includes("git")) return "󰊤"
        if (haystack.includes("postman")) return "󰛮"
        if (haystack.includes("steam")) return "󰓓"
        if (haystack.includes("lutris")) return "󰺵"
        if (haystack.includes("heroic")) return "󰊗"
        if (haystack.includes("settings") || cats.includes("settings")) return "󰒓"
        if (haystack.includes("calculator")) return "󰃬"
        if (haystack.includes("screenshot") || haystack.includes("flameshot") || haystack.includes("spectacle")) return "󰹑"
        if (haystack.includes("bitwarden") || haystack.includes("keepass")) return "󰌾"
        return "󰣆"
    }

    
    // Toggle function to be called from bar
    function toggle() {
        launcherVisible = !launcherVisible
        if (launcherVisible) {
            searchInput.focus = true
            searchInput.text = ""
            searchText = ""
            rebuildModel()
        }
    }

    Component.onCompleted: {
        // Common applications list
        var allApps = [
            // Browsers
            { name: "Firefox", icon: "󰈹", exec: "firefox", keywords: "browser web internet mozilla" },
            { name: "Chrome", icon: "󰊯", exec: "google-chrome-stable", keywords: "browser web internet google" },
            { name: "Chromium", icon: "󰊯", exec: "chromium", keywords: "browser web internet" },
            { name: "Brave", icon: "󰞍", exec: "brave", keywords: "browser web internet privacy" },
            { name: "Edge", icon: "󰇩", exec: "microsoft-edge", keywords: "browser web internet microsoft" },
            { name: "Opera", icon: "󰀫", exec: "opera", keywords: "browser web internet" },

            // Terminals
            { name: "Alacritty", icon: "󰆍", exec: "alacritty", keywords: "terminal shell command console" },
            { name: "Kitty", icon: "󰆍", exec: "kitty", keywords: "terminal shell command console" },
            { name: "Konsole", icon: "󰆍", exec: "konsole", keywords: "terminal shell command console kde" },
            { name: "Gnome Terminal", icon: "󰆍", exec: "gnome-terminal", keywords: "terminal shell command console gnome" },
            { name: "XFCE Terminal", icon: "󰆍", exec: "xfce4-terminal", keywords: "terminal shell command console xfce" },

            // File Managers
            { name: "Thunar", icon: "󰉋", exec: "thunar", keywords: "files manager explorer xfce" },
            { name: "Nautilus", icon: "󰉋", exec: "nautilus", keywords: "files manager explorer gnome" },
            { name: "Dolphin", icon: "󰉋", exec: "dolphin", keywords: "files manager explorer kde" },
            { name: "Nemo", icon: "󰉋", exec: "nemo", keywords: "files manager explorer cinnamon" },
            { name: "PCManFM", icon: "󰉋", exec: "pcmanfm", keywords: "files manager explorer lxde" },

            // Code Editors
            { name: "VS Code", icon: "󰨞", exec: "code", keywords: "editor ide programming vscode microsoft" },
            { name: "Code OSS", icon: "󰨞", exec: "code-oss", keywords: "editor ide programming vscode" },
            { name: "VSCodium", icon: "󰨞", exec: "vscodium", keywords: "editor ide programming vscode" },
            { name: "Emacs", icon: "", exec: "emacs", keywords: "editor text programming" },
            { name: "Sublime Text", icon: "󰘐", exec: "subl", keywords: "editor text programming sublime" },
            { name: "Gedit", icon: "󰷈", exec: "gedit", keywords: "editor text simple gnome" },

            // Communication
            { name: "Discord", icon: "󰙯", exec: "discord", keywords: "chat voice communication gaming" },
            { name: "Telegram", icon: "󰄫", exec: "telegram-desktop", keywords: "chat messaging communication" },
            { name: "Slack", icon: "󰒱", exec: "slack", keywords: "chat work team communication" },
            { name: "Signal", icon: "󰍡", exec: "signal-desktop", keywords: "chat messaging privacy encrypted" },
            { name: "Element", icon: "󰄫", exec: "element-desktop", keywords: "chat matrix messaging communication" },
            { name: "Thunderbird", icon: "󰇰", exec: "thunderbird", keywords: "email mail communication mozilla" },

            // Media
            { name: "Spotify", icon: "󰓇", exec: "spotify", keywords: "music streaming audio player" },
            { name: "VLC", icon: "󰕼", exec: "vlc", keywords: "media player video music streaming" },
            { name: "Audacity", icon: "󰝚", exec: "audacity", keywords: "audio editor recording music" },
            { name: "OBS Studio", icon: "󰑋", exec: "obs", keywords: "recording streaming video broadcast" },
            { name: "Kdenlive", icon: "󰈰", exec: "kdenlive", keywords: "video editor editing movie" },

            // Graphics
            { name: "GIMP", icon: "󰏘", exec: "gimp", keywords: "image editor photo graphics photoshop" },
            { name: "Inkscape", icon: "󰜡", exec: "inkscape", keywords: "vector graphics design svg illustrator" },
            { name: "Krita", icon: "󰏘", exec: "krita", keywords: "digital painting art drawing" },
            { name: "Blender", icon: "󰂫", exec: "blender", keywords: "3d modeling animation rendering" },

            // Office
            { name: "LibreOffice", icon: "󰈙", exec: "libreoffice", keywords: "office documents spreadsheet presentation" },
            { name: "LibreOffice Writer", icon: "󰈙", exec: "libreoffice", keywords: "office word document text" },
            { name: "LibreOffice Calc", icon: "󰪪", exec: "libreoffice", keywords: "office spreadsheet excel" },

            // Development
            { name: "GitKraken", icon: "󰊤", exec: "gitkraken", keywords: "git version control" },
            { name: "Postman", icon: "󰛮", exec: "postman", keywords: "api testing development http" },

            // Gaming
            { name: "Steam", icon: "󰓓", exec: "steam", keywords: "gaming games valve" },
            { name: "Lutris", icon: "󰺵", exec: "lutris", keywords: "gaming games wine linux" },
            { name: "Heroic", icon: "󰊗", exec: "heroic", keywords: "gaming games epic gog launcher" },

            // System
            { name: "System Monitor", icon: "󰍛", exec: "gnome-system-monitor", keywords: "system resources monitor performance cpu ram" },
            { name: "Htop", icon: "󰍛", exec: "htop", keywords: "system resources monitor terminal cpu ram" },
            { name: "Btop", icon: "󰍛", exec: "btop", keywords: "system resources monitor terminal cpu ram modern" },
            { name: "Settings", icon: "󰒓", exec: "gnome-control-center", keywords: "settings preferences config system gnome" },

            // Utilities
            { name: "Calculator", icon: "󰃬", exec: "gnome-calculator", keywords: "calculator math numbers" },
            { name: "Flameshot", icon: "󰹑", exec: "flameshot", keywords: "screenshot capture image annotate" },
            { name: "Spectacle", icon: "󰹑", exec: "spectacle", keywords: "screenshot capture image kde" },
            { name: "Transmission", icon: "󰶘", exec: "transmission-gtk", keywords: "torrent download p2p" },
            { name: "qBittorrent", icon: "󰶘", exec: "qbittorrent", keywords: "torrent download p2p" },
            { name: "Bitwarden", icon: "󰌾", exec: "bitwarden", keywords: "password manager security vault" },
            { name: "KeePassXC", icon: "󰌾", exec: "keepassxc", keywords: "password manager security vault" }
        ]

        // Check installation and add to model
        for (var i = 0; i < allApps.length; i++) {
            var app = allApps[i]
            var checkCmd = app.exec.split(" ")[0]
            var checkProcess = Qt.createQmlObject(
                'import QtQuick; import Quickshell.Io; Process { ' +
                'property var appToAdd: null; ' +
                'running: true; ' +
                'command: ["sh", "-c", "command -v ' + checkCmd + '"]; ' +
                'onExited: function(exitCode, exitStatus) { ' +
                '    if (exitCode === 0 && appToAdd) { ' +
                '        launcher.addApp(appToAdd); ' +
                '    } ' +
                '    destroy(); ' +
                '} ' +
                '}',
                launcher,
                "checkProcess" + i
            )
            checkProcess.appToAdd = app
        }

        desktopScan.running = true
    }

    Process {
        id: desktopScan
        running: false
        command: ["sh", "-c", "python - <<'PY'\nimport os, json, configparser, re\npaths = [\n    os.path.expanduser('~/.local/share/applications'),\n    '/usr/local/share/applications',\n    '/usr/share/applications',\n    os.path.expanduser('~/.local/share/flatpak/exports/share/applications'),\n    '/var/lib/flatpak/exports/share/applications'\n]\nseen = set()\nfor base in paths:\n    if not os.path.isdir(base):\n        continue\n    for root, _, files in os.walk(base):\n        for f in files:\n            if not f.endswith('.desktop'):\n                continue\n            path = os.path.join(root, f)\n            cp = configparser.ConfigParser(interpolation=None)\n            try:\n                cp.read(path, encoding='utf-8')\n            except Exception:\n                continue\n            if 'Desktop Entry' not in cp:\n                continue\n            d = cp['Desktop Entry']\n            if d.get('Type', 'Application') != 'Application':\n                continue\n            if d.get('NoDisplay', 'false').lower() == 'true':\n                continue\n            if d.get('Hidden', 'false').lower() == 'true':\n                continue\n            name = d.get('Name', '').strip()\n            exec_line = d.get('Exec', '').strip()\n            if not name or not exec_line:\n                continue\n            parts = exec_line.split()\n            exec_clean = ' '.join([p for p in parts if not p.startswith('%')])\n            exec_cmd = parts[0]\n            icon = d.get('Icon', '').strip()\n            keywords = ' '.join([d.get('Keywords', ''), d.get('Categories', '')]).strip()\n            key = exec_cmd\n            if key in seen:\n                continue\n            seen.add(key)\n            print(json.dumps({\n                'name': name,\n                'exec': exec_clean,\n                'iconName': icon,\n                'keywords': keywords,\n                'categories': d.get('Categories', ''),\n                'mtime': os.path.getmtime(path)\n            }))\nPY"]
        stdout: SplitParser {
            onRead: function(data) {
                var line = data.trim()
                if (line === "") return
                try {
                    var entry = JSON.parse(line)
                    launcher.addApp({
                        name: entry.name,
                        icon: launcher.nerdIconForDesktop(entry),
                        exec: entry.exec,
                        keywords: entry.keywords || "",
                        mtime: entry.mtime || 0
                    })
                } catch (e) {
                    // ignore parse errors
                }
            }
        }
    }
    
    // Background overlay
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: launcherVisible ? 0.7 : 0
        
        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: launcher.launcherVisible = false
        }
    }
    
    // Main launcher container
    Rectangle {
        id: launcherPanel
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.8, settings ? settings.launcherWidth : 900)
        height: Math.min(parent.height * 0.8, settings ? settings.launcherHeight : 700)
        color: settings ? Qt.rgba(settings.colorBackground.r, settings.colorBackground.g, settings.colorBackground.b, 0.95) : Qt.rgba(0.118, 0.118, 0.18, 0.95)
        radius: settings ? settings.launcherRadius : 16
        border.width: settings ? settings.launcherBorderWidth : 2
        border.color: settings ? settings.colorAccent : Qt.rgba(0.537, 0.706, 0.98, 0.4)
        
        // Scale animation
        scale: launcherVisible ? 1.0 : 0.9
        opacity: launcherVisible ? 1.0 : 0
        
        Behavior on scale {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutBack
                easing.overshoot: 1.2
            }
        }
        
        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            // Header with search
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10
                
                // Title
                Text {
                    text: "Applications"
                    font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                    font.pixelSize: settings ? settings.fontSizeValue + 2 : 24
                    font.bold: true
                    color: settings ? settings.colorAccent : "#89b4fa"
                    Layout.alignment: Qt.AlignHCenter
                }
                
                // Search bar
                Rectangle {
                    Layout.fillWidth: true
                    height: 50
                    color: settings ? settings.colorBackgroundAlt : Qt.rgba(0.196, 0.196, 0.266, 0.6)
                    radius: settings ? settings.radiusMedium : 12
                    border.width: settings ? settings.borderWidth : 2
                    border.color: searchInput.activeFocus ? (settings ? settings.colorAccent : "#89b4fa") : (settings ? settings.colorBorder : Qt.rgba(0.537, 0.706, 0.98, 0.3))
                    
                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12
                        
                        Text {
                            text: "󰍉"
                            font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                            font.pixelSize: settings ? settings.fontSizeIcon + 2 : 20
                            color: settings ? settings.colorAccent : "#89b4fa"
                        }
                        
                        TextInput {
                            id: searchInput
                            Layout.fillWidth: true
                            font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                            font.pixelSize: settings ? settings.fontSizeLabel + 2 : 16
                            color: settings ? settings.colorText : "#cdd6f4"
                            selectionColor: settings ? settings.colorAccent : "#89b4fa"
                            selectedTextColor: settings ? settings.colorBackground : "#1e1e2e"
                            
                            Text {
                                anchors.fill: parent
                                text: "Search applications..."
                                font: searchInput.font
                                color: settings ? settings.colorTextMuted : "#6c7086"
                                visible: !searchInput.text && !searchInput.activeFocus
                            }
                            
                            onTextChanged: {
                                launcher.searchText = text.toLowerCase()
                                launcher.rebuildModel()
                            }
                            
                            Keys.onEscapePressed: {
                                launcher.launcherVisible = false
                            }
                            
                            Keys.onReturnPressed: {
                                // Launch first visible app
                                for (var i = 0; i < appsModel.count; i++) {
                                    var app = appsModel.get(i)
                                    if (launcher.searchText === "" ||
                                        app.name.toLowerCase().includes(launcher.searchText) ||
                                        app.keywords.toLowerCase().includes(launcher.searchText)) {
                                        var proc = Qt.createQmlObject(
                                            'import QtQuick; import Quickshell.Io; Process { running: true; command: ["' + app.exec.split(' ')[0] + '"] }',
                                            launcher
                                        )
                                        launcher.launcherVisible = false
                                        break
                                    }
                                }
                            }
                        }
                        
                        Rectangle {
                            width: 32
                            height: 32
                            radius: settings ? settings.radiusSmall : 8
                            color: settings ? Qt.rgba(settings.colorError.r, settings.colorError.g, settings.colorError.b, 0.2) : Qt.rgba(0.957, 0.545, 0.659, 0.2)
                            visible: searchInput.text !== ""
                            
                            Text {
                                anchors.centerIn: parent
                                text: "✕"
                                font.pixelSize: 14
                                color: settings ? settings.colorError : "#f38ba8"
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    searchInput.text = ""
                                    searchInput.focus = true
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    ComboBox {
                        id: sortCombo
                        Layout.preferredWidth: 180
                        model: ["A-Z", "Z-A", "Modified", "Modified (Oldest)"]
                        currentIndex: 0
                        onCurrentTextChanged: {
                            launcher.sortMode = currentText
                            launcher.rebuildModel()
                        }
                    }

                    ComboBox {
                        id: viewCombo
                        Layout.preferredWidth: 120
                        model: ["Icon", "List"]
                        currentIndex: 0
                        onCurrentTextChanged: {
                            launcher.viewMode = currentText
                        }
                    }

                    Item { Layout.fillWidth: true }
                }
            }
            
            // App grid
            Component {
                id: iconDelegate

                Rectangle {
                    width: GridView.view.cellWidth - 10
                    height: GridView.view.cellHeight - 10
                    color: appMouseArea.containsMouse ?
                           (settings ? Qt.rgba(settings.colorAccent.r, settings.colorAccent.g, settings.colorAccent.b, 0.2) : Qt.rgba(0.537, 0.706, 0.98, 0.2)) :
                           (settings ? settings.colorBackgroundAlt : Qt.rgba(0.196, 0.196, 0.266, 0.4))
                    radius: settings ? settings.radiusMedium : 12
                    border.width: settings ? settings.borderWidth : 2
                    border.color: appMouseArea.containsMouse ?
                                 (settings ? settings.colorAccent : "#89b4fa") : "transparent"

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }

                    Item {
                        anchors.fill: parent
                        anchors.margins: 8
                        scale: appMouseArea.containsMouse ? 1.02 : 1.0

                        Behavior on scale {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8

                            Item {
                                Layout.alignment: Qt.AlignHCenter
                                width: settings ? settings.launcherIconSize : 48
                                height: settings ? settings.launcherIconSize : 48

                                Text {
                                    anchors.centerIn: parent
                                    text: model.icon && model.icon != "" ? model.icon : model.name.slice(0, 1).toUpperCase()
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: settings ? settings.launcherIconSize : 48
                                    color: appMouseArea.containsMouse ? (settings ? settings.colorAccent : "#89b4fa") : (settings ? settings.colorText : "#cdd6f4")
                                }
                            }

                            Text {
                                text: model.name
                                font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                                font.pixelSize: settings ? settings.fontSizeLabel : 13
                                font.bold: appMouseArea.containsMouse
                                color: settings ? settings.colorText : "#cdd6f4"
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter

                                Behavior on font.bold {
                                    NumberAnimation { duration: 150 }
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: appMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            var proc = Qt.createQmlObject(
                                'import QtQuick; import Quickshell.Io; Process { running: true; command: ["' + model.exec + '"] }',
                                launcher
                            )
                            launcher.launcherVisible = false
                        }
                    }
                }
            }

            Component {
                id: listDelegate

                Rectangle {
                    width: ListView.view.width
                    height: 56
                    color: appMouseArea.containsMouse ?
                           (settings ? Qt.rgba(settings.colorAccent.r, settings.colorAccent.g, settings.colorAccent.b, 0.2) : Qt.rgba(0.537, 0.706, 0.98, 0.2)) :
                           (settings ? settings.colorBackgroundAlt : Qt.rgba(0.196, 0.196, 0.266, 0.4))
                    radius: settings ? settings.radiusMedium : 12
                    border.width: settings ? settings.borderWidth : 2
                    border.color: appMouseArea.containsMouse ?
                                 (settings ? settings.colorAccent : "#89b4fa") : "transparent"

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Text {
                            text: model.icon && model.icon != "" ? model.icon : model.name.slice(0, 1).toUpperCase()
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: settings ? Math.max(24, Math.round(settings.launcherIconSize * 0.75)) : 32
                            color: appMouseArea.containsMouse ? (settings ? settings.colorAccent : "#89b4fa") : (settings ? settings.colorText : "#cdd6f4")
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: 36
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                            spacing: 2

                            Text {
                                text: model.name
                                font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                                font.pixelSize: settings ? settings.fontSizeLabel + 1 : 14
                                color: settings ? settings.colorText : "#cdd6f4"
                                horizontalAlignment: Text.AlignLeft
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }

                            Text {
                                text: model.exec
                                font.family: settings ? settings.fontFamily : "JetBrainsMono Nerd Font"
                                font.pixelSize: settings ? settings.fontSizeLabel - 2 : 11
                                color: settings ? settings.colorTextMuted : "#6c7086"
                                horizontalAlignment: Text.AlignLeft
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                maximumLineCount: 1
                            }
                        }
                    }

                    MouseArea {
                        id: appMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            var proc = Qt.createQmlObject(
                                'import QtQuick; import Quickshell.Io; Process { running: true; command: ["' + model.exec + '"] }',
                                launcher
                            )
                            launcher.launcherVisible = false
                        }
                    }
                }
            }

            Component {
                id: gridViewComponent

                GridView {
                    id: appGrid
                    anchors.fill: parent
                    cellWidth: 140
                    cellHeight: 140
                    clip: true
                    focus: true
                    boundsBehavior: Flickable.StopAtBounds
                    model: appsModel
                    delegate: iconDelegate

                    Keys.onEscapePressed: {
                        launcher.launcherVisible = false
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        contentItem: Rectangle {
                            implicitWidth: 8
                            radius: 4
                            color: Qt.rgba(0.537, 0.706, 0.98, 0.5)
                        }
                    }
                }
            }

            Component {
                id: listViewComponent

                ListView {
                    id: appList
                    anchors.fill: parent
                    clip: true
                    spacing: 10
                    focus: true
                    boundsBehavior: Flickable.StopAtBounds
                    model: appsModel
                    delegate: listDelegate

                    Keys.onEscapePressed: {
                        launcher.launcherVisible = false
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        contentItem: Rectangle {
                            implicitWidth: 8
                            radius: 4
                            color: Qt.rgba(0.537, 0.706, 0.98, 0.5)
                        }
                    }
                }
            }

            Item {
                id: appViewContainer
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                Loader {
                    anchors.fill: parent
                    sourceComponent: launcher.viewMode === "List" ? listViewComponent : gridViewComponent
                }
            }
            // Footer with stats
            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: Qt.rgba(0.196, 0.196, 0.266, 0.4)
                radius: 8
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    
                    Text {
                        text: {
                            var visibleCount = 0
                            for (var i = 0; i < appsModel.count; i++) {
                                var app = appsModel.get(i)
                                if (launcher.searchText === "" ||
                                    app.name.toLowerCase().includes(launcher.searchText) ||
                                    app.keywords.toLowerCase().includes(launcher.searchText)) {
                                    visibleCount++
                                }
                            }
                            return visibleCount + " applications"
                        }
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                        color: "#a6adc8"
                        Layout.fillWidth: true
                    }
                    
                    Text {
                        text: "ESC to close"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        color: "#6c7086"
                    }
                }
            }
        }
    }
    // Keys handlers are attached to Items below.
}

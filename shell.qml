import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    id: shell
    property var settings: settingsLoader.item

    Component.onCompleted: {
        Qt.application.organization = "drek"
        Qt.application.domain = "local"
        Qt.application.name = "quickshell"
        settingsLoader.active = true
    }

    Loader {
        id: settingsLoader
        active: false
        sourceComponent: settingsComponent
    }

    Component {
        id: settingsComponent
        Settings {}
    }

    Loader {
        id: uiLoader
        active: settingsLoader.item !== null
        sourceComponent: uiComponent
    }

    Component {
        id: uiComponent
        Item {
            // IPC handler for external control
            IpcHandler {
                target: "shell"

                function reload(): void {
                    Quickshell.reload(false)
                }

                function hardReload(): void {
                    Quickshell.reload(true)
                }

                function toggleControlCenter(): void {
                    controlCenterPanel.toggle()
                }

                function toggleSettings(): void {
                    settingsPanel.toggle()
                }
            }

            Launcher {
                id: appLauncher
                settings: settingsLoader.item
            }

            ControlCenter {
                id: controlCenterPanel
                settings: settingsLoader.item
                settingsPanel: settingsPanel
            }

            SettingsPanel {
                id: settingsPanel
                settings: settingsLoader.item
            }

            Bar {
                id: barComponent
                settings: settingsLoader.item
                launcherComponent: appLauncher
                controlCenterComponent: controlCenterPanel
                volumePopupComponent: volumePopupPanel
                wifiPopupComponent: wifiPopupPanel
            }

            VolumePopup {
                id: volumePopupPanel
                settings: settingsLoader.item
                currentVolume: barComponent.currentVolume
                volumeMuted: barComponent.volumeMuted
                onVolumeChanged: (vol) => barComponent.setVolume(vol)
                onMuteToggled: barComponent.toggleMute()
            }

            WifiPopup {
                id: wifiPopupPanel
                settings: settingsLoader.item
                wifiNetwork: barComponent.wifiNetwork
                wifiConnected: barComponent.wifiConnected
                wifiNetworks: barComponent.wifiNetworks
                onRefreshClicked: barComponent.scanWifi()
                onNetworkSelected: (ssid) => barComponent.connectWifi(ssid)
            }

            Dock {
                settings: settingsLoader.item
            }
        }
    }
}

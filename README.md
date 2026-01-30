# Aurora Bar

Aurora Bar is a Quickshell configuration for Hyprland that focuses on a clean, animated top bar with supporting panels and popups. It is designed to be lightweight, easy to tweak, and visually cohesive across its widgets.

## What's included
- Top bar with clock, workspace area, and system indicators
- Quick settings panel
- Notification center
- Dock / launcher
- Volume and Wi‑Fi popups
- Calendar, music, and system monitor panels

## Status
This is a design-first setup. Some widgets are placeholders and may require wiring to real system APIs (volume, network, media, etc.) depending on your Quickshell version and environment.

## Requirements
- Quickshell installed and running
- Qt6 (base, declarative, wayland)
- Optional: Nerd Fonts for icon glyphs

## Install
1) Install dependencies (Arch/Manjaro example):

```bash
sudo pacman -S qt6-base qt6-declarative qt6-wayland
```

2) Install Quickshell (AUR example):

```bash
paru -S quickshell-git
# or
yay -S quickshell-git
```

3) Copy the files into your Quickshell config directory:

```bash
mkdir -p ~/.config/quickshell
cp -r ./*.qml settings.ini README.md ~/.config/quickshell/
```

4) Start Quickshell:

```bash
quickshell
```

5) (Optional) Autostart via Hyprland:

```conf
exec-once = quickshell
```

## Configure
- Colors and timing values live in `shell.qml`.
- Bar layout and spacing in `Bar.qml`.
- Dock layout in `Dock.qml` and `DockIcon.qml`.
- Panels and popups in the corresponding `*.qml` files.

## Project structure
- `shell.qml` entry point
- `Bar.qml` main bar
- `Dock.qml` / `DockIcon.qml` dock
- `QuickSettings.qml` / `ControlCenter.qml`
- `NotificationCenter.qml`
- `VolumePopup.qml` / `WifiPopup.qml`
- `Calendar.qml` / `MusicPlayer.qml` / `SystemMonitor.qml`
- `Settings.qml` / `SettingsPanel.qml` / `settings.ini`

## Notes
If a panel does not react to system state, it likely needs a backend hook or Quickshell integration point added for your system. This repo focuses on the visual layer and structure to make that wiring straightforward.

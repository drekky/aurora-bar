# Quickshell Catppuccin Mocha Setup

A stunning, highly animated, and customizable Quickshell configuration matching your Hyprland/Waybar aesthetic.

## ⚠️ Important Note

**Quickshell is currently in development and this is an advanced starter template.** While the components are designed with beautiful animations and Catppuccin Mocha theming, you'll need to:

1. Have Quickshell installed and working
2. Potentially adjust QML syntax for your Quickshell version
3. Integrate with actual system APIs for live data
4. Add proper error handling

This configuration provides the visual foundation - you may need to wire up actual functionality.

## Features

✨ **Beautiful Animations**
- Smooth entrance animations
- Hover effects with scale and glow
- Slide-in panels
- Bouncing dock icons
- Color transitions

🎨 **Catppuccin Mocha Theme**
- Consistent color palette throughout
- Glass-morphism effects
- Rounded corners and soft shadows

🚀 **Components Included**
- **Animated Top Bar** - Time, workspaces, system info
- **Floating Dock** - App launcher with hover effects
- **Quick Settings Panel** - Slides in from right
- **Placeholders** - Calendar, Music Player, Notifications, System Monitor

⚙️ **Highly Customizable**
- All colors defined in one place
- Adjustable animation speeds
- Easy to add/remove dock apps
- Modular component design

## Installation

### 1. Install Quickshell

**From AUR (Arch/Garuda):**
```bash
paru -S quickshell-git
# or
yay -S quickshell-git
```

**From Source:**
```bash
git clone https://github.com/outfoxxed/quickshell.git
cd quickshell
mkdir build && cd build
cmake ..
make
sudo make install
```

### 2. Install Dependencies

```bash
# Required
sudo pacman -S qt6-base qt6-declarative qt6-wayland

# Optional (for full functionality)
sudo pacman -S \
    wofi \              # App launcher
    wlogout \           # Power menu
    pavucontrol \       # Volume control
    nm-connection-editor \  # Network settings
    brightnessctl \     # Brightness control
    playerctl           # Media controls
```

### 3. Install Configuration

```bash
# Create Quickshell config directory
mkdir -p ~/.config/quickshell

# Copy all QML files
cp quickshell/*.qml ~/.config/quickshell/

# The file structure should be:
# ~/.config/quickshell/
# ├── shell.qml          (main entry point)
# ├── Bar.qml
# ├── Dock.qml
# ├── QuickSettings.qml
# ├── NotificationCenter.qml
# ├── Calendar.qml
# ├── MusicPlayer.qml
# └── SystemMonitor.qml
```

### 4. Launch Quickshell

```bash
# Test run
quickshell

# If it works, add to Hyprland autostart
echo "exec-once = quickshell" >> ~/.config/hypr/hyprland.conf
```

## Configuration

### Changing Colors

All colors are defined in `shell.qml`. Modify the color properties:

```qml
readonly property color blue: "#89b4fa"
readonly property color green: "#a6e3a1"
// etc...
```

### Adjusting Animation Speed

In `shell.qml`:

```qml
readonly property int animationDuration: 300  // Standard animations
readonly property int fastAnimation: 150      // Quick transitions
readonly property int slowAnimation: 500      // Entrance animations
```

### Customizing Dock Apps

Edit `Dock.qml` and modify the `DockIcon` components:

```qml
DockIcon {
    iconText: "󰈹"          // Nerd Font icon
    appName: "Your App"     // Tooltip text
    command: "your-command" // Command to execute
    color: root.blue        // Icon color
}
```

**Find Nerd Font Icons:**
- Browse: https://www.nerdfonts.com/cheat-sheet
- Or use: `fc-list | grep Nerd`

### Changing Bar Position

In `Bar.qml`:

```qml
anchors {
    top: true    // Change to false for bottom bar
    left: true
    right: true
}
```

### Dock Position

In `Dock.qml`:

```qml
anchors {
    bottom: true  // Change to top: true for top dock
    left: false
    right: false
}
```

## Component Details

### Bar.qml
**Features:**
- App launcher button
- Workspace indicators (1-9)
- Active window title
- Animated clock
- Volume, network, battery indicators
- Power menu button

**Customization:**
- Change workspace count in the Repeater model
- Modify icon colors for different states
- Adjust spacing and sizing

### Dock.qml
**Features:**
- Floating app icons
- Hover animations with bounce effect
- Tooltips on hover
- App separators
- Customizable icon layout

**Customization:**
- Add/remove app icons
- Change hover scale factor
- Modify bounce animation
- Adjust dock width/height

### QuickSettings.qml
**Features:**
- System stats (CPU, RAM, Temp)
- Quick toggles (WiFi, Bluetooth, DND, Night Light)
- Volume slider
- Brightness slider
- Power buttons (Sleep, Restart, Shutdown)

**Trigger:**
- Currently requires manual trigger
- You can wire it to a keybind or button click

**Customization:**
- Add more quick toggles
- Change toggle layout (3 columns, etc.)
- Add more sliders (e.g., keyboard backlight)

## Integration Tasks

To make this fully functional, you'll need to:

### 1. Real-Time Data
Connect to actual system data sources:

```qml
// Example for battery (pseudo-code)
property real batteryLevel: BatteryMonitor.percentage

// For volume
property int volumeLevel: PulseAudio.volume
```

### 2. Workspace Integration
Wire up Hyprland workspace changes:

```qml
Hyprland.activeWorkspace.changed.connect(() => {
    currentWorkspace = Hyprland.activeWorkspace
})
```

### 3. System Commands
Ensure commands execute properly:

```qml
Process {
    id: volumeProcess
    command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", value + "%"]
}
```

### 4. Keybinds
Add Hyprland keybinds in `hyprland.conf`:

```conf
# Toggle quick settings
bind = SUPER, E, exec, quickshell-toggle-panel
```

## Keyboard Shortcuts

Add these to `~/.config/hypr/hyprland.conf`:

```conf
# Quickshell controls
bind = SUPER, SPACE, exec, wofi --show drun
bind = SUPER, E, exec, # toggle quick settings (needs implementation)
bind = SUPER, N, exec, # toggle notifications (needs implementation)
```

## Troubleshooting

**Quickshell won't start:**
```bash
# Check for errors
quickshell -l debug

# Verify Qt6 is installed
pacman -Q qt6-base qt6-declarative

# Check QML syntax
qml shell.qml
```

**Components not showing:**
- Check that all .qml files are in `~/.config/quickshell/`
- Verify file permissions: `chmod 644 ~/.config/quickshell/*.qml`
- Look for errors in the console output

**Icons not displaying:**
- Install Nerd Fonts: `sudo pacman -S ttf-jetbrains-mono-nerd`
- Refresh font cache: `fc-cache -fv`

**Animations laggy:**
- Reduce animation duration in `shell.qml`
- Disable certain effects (glow, blur)
- Check GPU acceleration

**Bar/Dock not positioning correctly:**
- Adjust margins in the respective .qml files
- Check for conflicts with other bars
- Verify Hyprland is recognizing layershell windows

## Advanced Customization

### Add Blur Effect

In component backgrounds:

```qml
Rectangle {
    color: Qt.rgba(0.118, 0.118, 0.18, 0.85)
    
    layer.enabled: true
    layer.effect: GaussianBlur {
        radius: 32
        samples: 16
    }
}
```

### Add Glow to Elements

```qml
Rectangle {
    layer.enabled: true
    layer.effect: Glow {
        radius: 16
        samples: 24
        color: root.blue
        spread: 0.3
    }
}
```

### Custom Workspace Icons

In `Bar.qml`, replace workspace numbers:

```qml
Text {
    text: ["", "", "", "", "", "", "", "", ""][modelData]
    // Instead of: text: parent.workspaceId
}
```

## Color Palette Reference

Full Catppuccin Mocha colors available:

| Name | Hex | Usage |
|------|-----|-------|
| Blue | `#89b4fa` | Primary accent |
| Green | `#a6e3a1` | Success states |
| Yellow | `#f9e2af` | Warnings |
| Red | `#f38ba8` | Errors/Power |
| Mauve | `#cba6f7` | Secondary accent |
| Base | `#1e1e2e` | Backgrounds |
| Text | `#cdd6f4` | Primary text |

## Performance Tips

1. **Reduce particles/effects** if laggy
2. **Use simpler animations** on lower-end hardware
3. **Disable blur effects** for better FPS
4. **Limit simultaneous animations**
5. **Use `visible: false`** instead of `opacity: 0` when hiding

## Development

Want to extend this setup?

1. **Add widgets:** Create new .qml files, import in shell.qml
2. **Connect to APIs:** Use Quickshell's system integration features
3. **Share your work:** These configs are meant to be customized!

## Resources

- **Quickshell Docs:** https://outfoxxed.me/quickshell/
- **QML Reference:** https://doc.qt.io/qt-6/qmlapplications.html
- **Catppuccin:** https://catppuccin.com/
- **Nerd Fonts:** https://www.nerdfonts.com/

## Known Limitations

- Some components are placeholders (Calendar, MusicPlayer, etc.)
- Real-time data requires additional integration
- Panel toggles need keybind implementation
- System stats need actual monitoring integration

## Contributing

This is a starter template! Feel free to:
- Implement the placeholder components
- Add new features
- Improve animations
- Fix bugs
- Share improvements

Enjoy your beautiful Quickshell setup! 🚀🎨

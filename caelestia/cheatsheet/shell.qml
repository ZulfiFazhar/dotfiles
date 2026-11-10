pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    id: root

    FileView {
        id: schemeFile
        path: `${Quickshell.env("HOME")}/.local/state/caelestia/scheme.json`
    }

    readonly property var colours: {
        try {
            return JSON.parse(schemeFile.text()).colours || {};
        } catch (e) {
            return {};
        }
    }

    // Dynamic colours matching Caelestia
    readonly property color colBg: colours.background ? `#${colours.background}` : "#131317"
    readonly property color colSurface: colours.surfaceContainer ? `#${colours.surfaceContainer}` : "#1f1f23"
    readonly property color colSurfaceHigh: colours.surfaceContainerHigh ? `#${colours.surfaceContainerHigh}` : "#2a2a2e"
    readonly property color colPrimary: colours.primary ? `#${colours.primary}` : "#bac3ff"
    readonly property color colOnSurface: colours.onSurface ? `#${colours.onSurface}` : "#e4e1e7"
    readonly property color colOnVariant: colours.onSurfaceVariant ? `#${colours.onSurfaceVariant}` : "#a8abb5"
    readonly property color colOutline: colours.outline ? `#${colours.outline}` : "#46464f"
    readonly property color colKeyBg: colours.surfaceVariant ? `#${colours.surfaceVariant}` : "#32363e"

    // Default language is now English (EN)
    property string lang: "en" // "en" or "id"
    property string searchQuery: ""

    readonly property var rawData: [
        {
            icon: "apps",
            category_id: "Aplikasi & Sistem",
            category_en: "Apps & System",
            items: [
                { key: "Super", id: "Buka App Launcher (>wallpaper, >scheme)", en: "Open App Launcher (>wallpaper, >scheme)" },
                { key: "Super + T", id: "Terminal (foot)", en: "Terminal (foot)" },
                { key: "Super + W", id: "Web Browser (zen)", en: "Web Browser (zen)" },
                { key: "Super + E", id: "File Manager (thunar)", en: "File Manager (thunar)" },
                { key: "Super + C", id: "Code / Text Editor", en: "Code / Text Editor" },
                { key: "Ctrl + Alt + V", id: "Pengaturan Audio (pwvucontrol)", en: "Audio Settings (pwvucontrol)" },
                { key: "Super + L", id: "Kunci Layar (Lock Screen)", en: "Lock Screen" },
                { key: "Super + Shift + L", id: "Mode Tidur (Sleep / Suspend)", en: "Sleep / Suspend Mode" },
                { key: "Ctrl + Alt + Delete", id: "Menu Sesi (Shutdown / Reboot / Logout)", en: "Session Menu (Shutdown / Reboot / Logout)" },
                { key: "Super + N", id: "Buka / Tutup Sidebar Notifikasi", en: "Toggle Notification Sidebar" },
                { key: "Super + K", id: "Tampilkan Semua Panel Shell", en: "Show All Shell Panels" },
                { key: "Ctrl + Alt + C", id: "Bersihkan Riwayat Notifikasi", en: "Clear Notification History" }
            ]
        },
        {
            icon: "desktop_windows",
            category_id: "Manajemen Window",
            category_en: "Window Management",
            items: [
                { key: "Super + Q", id: "Tutup Window Aktif", en: "Close Active Window" },
                { key: "Super + F", id: "Fullscreen Penuh", en: "Fullscreen" },
                { key: "Super + Alt + F", id: "Fullscreen (Border Tetap Ada)", en: "Fullscreen (Keep Border)" },
                { key: "Super + Alt + Space", id: "Toggle Floating Window", en: "Toggle Floating Window" },
                { key: "Super + P", id: "Pin Window (Tampil di Semua Workspace)", en: "Pin Window (Show across all workspaces)" },
                { key: "Super + Alt + \\", id: "Mode Picture-in-Picture", en: "Picture-in-Picture Mode" },
                { key: "Ctrl + Super + \\", id: "Tengahkan Window di Layar (Center)", en: "Center Window on Screen" },
                { key: "Ctrl + Super + Alt + \\", id: "Resize ke 55x70% lalu Tengahkan", en: "Resize to 55x70% and Center" },
                { key: "Super + Panah", id: "Pindah Fokus Window (Kiri/Kanan/Atas/Bawah)", en: "Focus Window in Direction (Left/Right/Up/Down)" },
                { key: "Super + Shift + Panah", id: "Tukar Posisi Window", en: "Swap / Move Window Position" },
                { key: "Super + Z + Drag Kiri", id: "Geser Posisi Window (Drag)", en: "Move Window (Drag)" },
                { key: "Super + X + Drag Kanan", id: "Ubah Ukuran Window (Resize)", en: "Resize Window (Drag)" },
                { key: "Super + [-] / [=]", id: "Kecilkan / Besarkan Lebar Window", en: "Decrease / Increase Window Width" },
                { key: "Super + Shift + [-] / [=]", id: "Kecilkan / Besarkan Tinggi Window", en: "Decrease / Increase Window Height" }
            ]
        },
        {
            icon: "tab",
            category_id: "Tabbed Window / Group",
            category_en: "Tabbed Window Groups",
            items: [
                { key: "Super + , (Koma)", id: "Gabungkan ke Group Tab", en: "Toggle Tabbed Group" },
                { key: "Super + U", id: "Keluarkan dari Group Tab", en: "Move Window Out of Group" },
                { key: "Alt + Tab", id: "Pindah ke Tab Berikutnya di Group", en: "Next Window in Group" },
                { key: "Shift + Alt + Tab", id: "Pindah ke Tab Sebelumnya di Group", en: "Previous Window in Group" },
                { key: "Ctrl + Alt + Tab", id: "Pindah ke Group Berikutnya", en: "Next Window Group" },
                { key: "Super + Shift + ,", id: "Kunci Window dalam Group", en: "Lock Active Window Group" }
            ]
        },
        {
            icon: "grid_view",
            category_id: "Workspace & Scratchpad",
            category_en: "Workspace & Scratchpad",
            items: [
                { key: "Super + 1..0", id: "Pindah ke Workspace 1 s/d 10", en: "Switch to Workspace 1 - 10" },
                { key: "Super + Alt + 1..0", id: "Pindahkan Window ke Workspace 1 s/d 10", en: "Move Window to Workspace 1 - 10" },
                { key: "Super + PgDown / PgUp", id: "Pindah ke Workspace Berikutnya / Sebelumnya", en: "Next / Previous Workspace" },
                { key: "Super + Alt + PgDown / PgUp", id: "Pindahkan Window ke Workspace Lain", en: "Move Window to Next / Prev Workspace" },
                { key: "Super + S", id: "Buka / Tutup Scratchpad Utama", en: "Toggle Special Workspace (Scratchpad)" },
                { key: "Super + Alt + S", id: "Kirim Window Aktif ke Scratchpad", en: "Move Window to Scratchpad" },
                { key: "Ctrl + Super + Shift + Bawah", id: "Keluarkan Window dari Scratchpad", en: "Move Window Out of Scratchpad" },
                { key: "Super + M", id: "Workspace Musik", en: "Music Workspace" },
                { key: "Super + D", id: "Workspace Komunikasi / Chat", en: "Communication Workspace" },
                { key: "Super + R", id: "Workspace Todo List", en: "Todo List Workspace" },
                { key: "Ctrl + Shift + Esc", id: "Workspace System Monitor (btop)", en: "System Monitor Workspace (btop)" }
            ]
        },
        {
            icon: "content_paste",
            category_id: "Clipboard, Emoji & Utilitas",
            category_en: "Clipboard, Emoji & Utilities",
            items: [
                { key: "Super + V", id: "Buka Riwayat Clipboard", en: "Open Clipboard History" },
                { key: "Super + Alt + V", id: "Hapus Item dari Clipboard", en: "Delete Item from Clipboard History" },
                { key: "Super + . (Titik)", id: "Emoji & Glyph Picker", en: "Emoji & Glyph Picker" },
                { key: "Print", id: "Screenshot Seluruh Layar", en: "Full Screen Screenshot" },
                { key: "Super + Shift + S", id: "Screenshot Area (Freeze Layar)", en: "Freeze Screen Area Screenshot" },
                { key: "Super + Shift + Alt + S", id: "Screenshot Area Cepat", en: "Quick Region Screenshot" },
                { key: "Super + Shift + C", id: "Color Picker (Salin Hex Warna Layar)", en: "Color Picker (Copy Hex Color)" },
                { key: "Ctrl + Alt + R", id: "Rekam Layar Penuh", en: "Full Screen Recording" },
                { key: "Super + Alt + R", id: "Rekam Layar dengan Audio", en: "Screen Recording with Audio" },
                { key: "Super + Shift + Alt + R", id: "Rekam Layar Area Tertentu", en: "Region Screen Recording" }
            ]
        },
        {
            icon: "play_circle",
            category_id: "Kontrol Media & Volume",
            category_en: "Media & Volume Controls",
            items: [
                { key: "Ctrl + Super + Space", id: "Play / Pause Media", en: "Play / Pause Media" },
                { key: "Ctrl + Super + =", id: "Lagu / Track Berikutnya", en: "Next Track" },
                { key: "Ctrl + Super + -", id: "Lagu / Track Sebelumnya", en: "Previous Track" },
                { key: "Ctrl + Super + Backspace", id: "Stop Playback Media", en: "Stop Media Playback" },
                { key: "Super + Shift + M", id: "Mute / Unmute Volume Speaker", en: "Toggle Speaker Mute" },
                { key: "XF86AudioRaiseVolume", id: "Naikkan Volume Suara", en: "Raise Volume" },
                { key: "XF86AudioLowerVolume", id: "Turunkan Volume Suara", en: "Lower Volume" }
            ]
        },
        {
            icon: "touch_app",
            category_id: "Trackpad Gestures",
            category_en: "Trackpad Gestures",
            items: [
                { key: "Swipe 4 Jari (Kiri / Kanan)", id: "Pindah Workspace", en: "Switch Workspaces" },
                { key: "Swipe 3 Jari (Ke Atas)", id: "Buka Scratchpad", en: "Open Scratchpad" },
                { key: "Swipe 3 Jari (Ke Bawah)", id: "Tutup Scratchpad", en: "Close Scratchpad" },
                { key: "Swipe 4 Jari (Ke Bawah)", id: "Mode Tidur (Sleep)", en: "Sleep Mode" }
            ]
        },
        {
            icon: "build",
            category_id: "Recovery & Bantuan",
            category_en: "Recovery & Help",
            items: [
                { key: "Super + Shift + K", id: "Buka Pop-up Cheatsheet Ini", en: "Open This Cheatsheet Popup" },
                { key: "Ctrl + Super + Alt + R", id: "Restart Shell Caelestia (Bila Macet)", en: "Restart Caelestia Shell" },
                { key: "Ctrl + Super + Shift + R", id: "Matikan Paksa Shell Caelestia", en: "Kill Caelestia Shell" }
            ]
        }
    ]

    readonly property var filteredItems: {
        const query = root.searchQuery.toLowerCase().trim();
        const res = [];
        for (let i = 0; i < root.rawData.length; i++) {
            const cat = root.rawData[i];
            const catTitle = root.lang === "en" ? cat.category_en : cat.category_id;
            const matchingItems = [];

            for (let j = 0; j < cat.items.length; j++) {
                const it = cat.items[j];
                const desc = root.lang === "en" ? it.en : it.id;
                if (!query || it.key.toLowerCase().includes(query) || desc.toLowerCase().includes(query) || catTitle.toLowerCase().includes(query)) {
                    matchingItems.push(it);
                }
            }

            if (matchingItems.length > 0) {
                res.push({ isHeader: true, title: catTitle, icon: cat.icon || "category" });
                for (let k = 0; k < matchingItems.length; k++) {
                    res.push({
                        isHeader: false,
                        key: matchingItems[k].key,
                        desc: root.lang === "en" ? matchingItems[k].en : matchingItems[k].id
                    });
                }
            }
        }
        return res;
    }

    PanelWindow {
        id: win
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        // Close on Esc
        Item {
            focus: true
            Keys.onEscapePressed: Qt.quit()
        }

        // Close when clicking outside modal
        MouseArea {
            anchors.fill: parent
            onClicked: Qt.quit()
        }

        // Main Card
        Rectangle {
            id: card
            anchors.centerIn: parent
            width: 760
            height: 600
            color: root.colBg
            radius: 20
            border.color: root.colOutline
            border.width: 1

            // Prevent clicks inside card from closing
            MouseArea {
                anchors.fill: parent
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                // Top Header Row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14

                    // Header Icon
                    Rectangle {
                        width: 42
                        height: 42
                        radius: 12
                        color: root.colSurface
                        border.color: root.colOutline
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            font.family: "Material Symbols Rounded"
                            text: "keyboard_command_key"
                            font.pixelSize: 22
                            color: root.colPrimary
                        }
                    }

                    ColumnLayout {
                        spacing: 2

                        Text {
                            text: "Caelestia Cheatsheet"
                            color: root.colOnSurface
                            font.family: "JetBrains Mono NF, Rubik, sans-serif"
                            font.pixelSize: 19
                            font.bold: true
                        }

                        Text {
                            text: root.lang === "en" ? "Complete keyboard shortcuts & gesture reference" : "Daftar pintasan keyboard & gesture lengkap"
                            color: root.colOnVariant
                            font.family: "JetBrains Mono NF, Rubik, sans-serif"
                            font.pixelSize: 12
                        }
                    }

                    // Flexible Spacer pushes language toggle and close button to far right
                    Item {
                        Layout.fillWidth: true
                    }

                    // Mouse-clickable Language Switcher Pill
                    Rectangle {
                        Layout.alignment: Qt.AlignVCenter
                        width: 130
                        height: 36
                        radius: 18
                        color: root.colSurface
                        border.color: root.colOutline
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            // English Button (Default)
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 18
                                color: root.lang === "en" ? root.colPrimary : "transparent"

                                RowLayout {
                                    anchors.centerIn: parent
                                    spacing: 4

                                    Text {
                                        font.family: "Material Symbols Rounded"
                                        text: "translate"
                                        font.pixelSize: 14
                                        color: root.lang === "en" ? "#131317" : root.colOnVariant
                                        visible: root.lang === "en"
                                    }

                                    Text {
                                        text: "EN"
                                        font.bold: root.lang === "en"
                                        font.pixelSize: 12
                                        font.family: "JetBrains Mono NF, sans-serif"
                                        color: root.lang === "en" ? "#131317" : root.colOnVariant
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.lang = "en"
                                }
                            }

                            // Indonesia Button
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 18
                                color: root.lang === "id" ? root.colPrimary : "transparent"

                                RowLayout {
                                    anchors.centerIn: parent
                                    spacing: 4

                                    Text {
                                        font.family: "Material Symbols Rounded"
                                        text: "translate"
                                        font.pixelSize: 14
                                        color: root.lang === "id" ? "#131317" : root.colOnVariant
                                        visible: root.lang === "id"
                                    }

                                    Text {
                                        text: "ID"
                                        font.bold: root.lang === "id"
                                        font.pixelSize: 12
                                        font.family: "JetBrains Mono NF, sans-serif"
                                        color: root.lang === "id" ? "#131317" : root.colOnVariant
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.lang = "id"
                                }
                            }
                        }
                    }

                    // Close Button
                    Rectangle {
                        Layout.alignment: Qt.AlignVCenter
                        width: 36
                        height: 36
                        radius: 18
                        color: closeArea.containsMouse ? root.colSurfaceHigh : root.colSurface
                        border.color: root.colOutline
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            font.family: "Material Symbols Rounded"
                            text: "close"
                            font.pixelSize: 18
                            color: root.colOnSurface
                        }

                        MouseArea {
                            id: closeArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Qt.quit()
                        }
                    }
                }

                // Search Bar
                Rectangle {
                    Layout.fillWidth: true
                    height: 42
                    radius: 12
                    color: root.colSurface
                    border.color: inputSearch.activeFocus ? root.colPrimary : root.colOutline
                    border.width: inputSearch.activeFocus ? 2 : 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 10

                        Text {
                            font.family: "Material Symbols Rounded"
                            text: "search"
                            font.pixelSize: 18
                            color: root.colOnVariant
                        }

                        TextInput {
                            id: inputSearch
                            Layout.fillWidth: true
                            color: root.colOnSurface
                            font.pixelSize: 13
                            font.family: "JetBrains Mono NF, sans-serif"
                            clip: true
                            focus: true
                            onTextChanged: root.searchQuery = text

                            Text {
                                text: root.lang === "en" ? "Search shortcuts (e.g. window, workspace, audio)..." : "Cari shortcut (cth: window, workspace, audio)..."
                                color: root.colOnVariant
                                visible: !inputSearch.text
                                font.pixelSize: 13
                                font.family: "JetBrains Mono NF, sans-serif"
                            }
                        }

                        // Clear search button
                        Rectangle {
                            visible: inputSearch.text.length > 0
                            width: 24
                            height: 24
                            radius: 12
                            color: clearArea.containsMouse ? root.colSurfaceHigh : "transparent"

                            Text {
                                anchors.centerIn: parent
                                font.family: "Material Symbols Rounded"
                                text: "close"
                                font.pixelSize: 16
                                color: root.colOnVariant
                            }

                            MouseArea {
                                id: clearArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    inputSearch.text = "";
                                    inputSearch.forceActiveFocus();
                                }
                            }
                        }
                    }
                }

                // Scrollable List of Shortcuts
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"
                    clip: true

                    ListView {
                        id: listView
                        anchors.fill: parent
                        anchors.rightMargin: 10
                        model: root.filteredItems
                        spacing: 8
                        clip: true

                        ScrollBar.vertical: ScrollBar {
                            active: true
                            width: 6
                            policy: ScrollBar.AsNeeded
                            contentItem: Rectangle {
                                implicitWidth: 6
                                radius: 3
                                color: root.colOutline
                            }
                        }

                        delegate: Item {
                            required property var modelData
                            width: listView.width
                            height: modelData.isHeader ? 34 : Math.max(38, itemRow.implicitHeight + 10)

                            // Header delegate
                            RowLayout {
                                visible: modelData.isHeader
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 4
                                spacing: 8

                                Text {
                                    font.family: "Material Symbols Rounded"
                                    text: modelData.icon || "category"
                                    font.pixelSize: 18
                                    color: root.colPrimary
                                }

                                Text {
                                    text: modelData.title || ""
                                    color: root.colPrimary
                                    font.family: "JetBrains Mono NF, Rubik, sans-serif"
                                    font.pixelSize: 13
                                    font.bold: true
                                }
                            }

                            // Item delegate
                            Rectangle {
                                visible: !modelData.isHeader
                                anchors.fill: parent
                                radius: 8
                                color: itemHover.containsMouse ? root.colSurfaceHigh : root.colSurface
                                border.color: itemHover.containsMouse ? root.colOutline : "transparent"
                                border.width: 1

                                MouseArea {
                                    id: itemHover
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }

                                RowLayout {
                                    id: itemRow
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    spacing: 16

                                    // Key badge
                                    Rectangle {
                                        Layout.preferredWidth: Math.max(140, keyText.implicitWidth + 16)
                                        Layout.preferredHeight: 26
                                        radius: 6
                                        color: root.colKeyBg
                                        border.color: root.colOutline
                                        border.width: 1

                                        Text {
                                            id: keyText
                                            anchors.centerIn: parent
                                            text: modelData.key || ""
                                            color: root.colPrimary
                                            font.bold: true
                                            font.pixelSize: 11
                                            font.family: "JetBrains Mono NF, monospace"
                                        }
                                    }

                                    // Description
                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.desc || ""
                                        color: root.colOnSurface
                                        font.pixelSize: 12
                                        font.family: "JetBrains Mono NF, Rubik, sans-serif"
                                        elide: Text.ElideRight
                                        wrapMode: Text.Wrap
                                    }
                                }
                            }
                        }
                    }
                }

                // Footer hint
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Text {
                        font.family: "Material Symbols Rounded"
                        text: "info"
                        font.pixelSize: 14
                        color: root.colOnVariant
                    }

                    Text {
                        text: root.lang === "en" ? "Press ESC or click outside to dismiss • Mouse wheel to scroll" : "Tekan ESC atau klik luar untuk keluar • Mouse wheel untuk scroll"
                        color: root.colOnVariant
                        font.pixelSize: 11
                        font.family: "JetBrains Mono NF, sans-serif"
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: `${root.filteredItems.filter(x => !x.isHeader).length} shortcuts`
                        color: root.colOnVariant
                        font.pixelSize: 11
                        font.family: "JetBrains Mono NF, sans-serif"
                    }
                }
            }
        }
    }
}

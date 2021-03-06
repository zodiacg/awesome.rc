xdgmenu = function(terminal)
  return {
    {"互联网", {
        {"Google Chrome (unstable)", "/usr/bin/google-chrome-unstable ", "/usr/share//icons/hicolor/16x16/apps/google-chrome-unstable.png" },
        {"Pidgin Internet Messenger", "pidgin", "/usr/share//icons/hicolor/16x16/apps/pidgin.png" },
        {"QQ国际版", "/usr/bin/wine-qqintl", "/usr/share//icons/hicolor/64x64/apps/qqintl.png" },
        {"Shadowsocks-Qt5", "ss-qt5"},
        {"Transmission", "transmission-gtk ", "/usr/share//icons/hicolor/16x16/apps/transmission.png" },
        {"小企鹅皮肤配置向导", "/usr/bin/fcitx-qimpanel-configtool", "/usr/share/pixmaps/fcitx_ubuntukylin.png" },
    }},
    {"办公", {
        {"AbiWord", "abiword ", "/usr/share//icons/hicolor/16x16/apps/abiword.png" },
        {"Document Viewer", "evince ", "/usr/share//icons/hicolor/16x16/apps/evince.png" },
        {"Gnumeric", "gnumeric ", "/usr/share//icons/hicolor/16x16/apps/gnumeric.png" },
        {"Orage 全球时间", "globaltime", "/usr/share//icons/hicolor/48x48/apps/orage_globaltime.png" },
        {"Orage 日历", "orage ", "/usr/share//icons/hicolor/48x48/apps/xfcalendar.png" },
        {"WPS 文字", "/usr/bin/wps ", "/usr/share//icons/hicolor/48x48/apps/wps-office-wpsmain.png" },
        {"WPS 演示", "/usr/bin/wpp ", "/usr/share//icons/hicolor/48x48/apps/wps-office-wppmain.png" },
        {"WPS 表格", "/usr/bin/et ", "/usr/share//icons/hicolor/48x48/apps/wps-office-etmain.png" },
        {"词典", "xfce4-dict"},
    }},
    {"图形", {
        {"Document Viewer", "evince ", "/usr/share//icons/hicolor/16x16/apps/evince.png" },
        {"Font Manager", "font-manager", "/usr/share//icons/gnome/16x16/apps/preferences-desktop-font.png" },
        {"GIMP Image Editor", "gimp-2.8 ", "/usr/share//icons/hicolor/16x16/apps/gimp.png" },
        {"R", (terminal or "xterm") .. " -e R", "/usr/share//icons/hicolor/48x48/apps/rlogo_icon.png" },
        {"Ristretto 图片查看器", "ristretto ", "/usr/share//icons/hicolor/16x16/apps/ristretto.png" },
        {"Simple Scan", "simple-scan", "/usr/share//icons/gnome/16x16/devices/scanner.png" },
    }},
    {"多媒体", {
        {"Parole 媒体播放器", "parole ", "/usr/share//icons/hicolor/16x16/apps/parole.png" },
        {"PulseAudio 音量控制", "pavucontrol", "/usr/share//icons/gnome/16x16/apps/multimedia-volume-control.png" },
        {"Xfburn 刻录程序", "xfburn"},
        {"gmusicbrowser", "gmusicbrowser ", "/usr/share//icons/mini/gmusicbrowser.png" },
        {"mpv Media Player", "mpv --profile=pseudo-gui -- ", "/usr/share//icons/hicolor/16x16/apps/mpv.png" },
        {"深度音乐", "deepin-music-player "},
    }},
    {"开发", {
        {"Android Studio", "\"/home/leoliu/AndroidSDK/android-studio/bin/studio.sh\" ", "///home/leoliu/AndroidSDK/android-studio/bin/studio.png" },
        {"Atom", "/opt/atom/atom ", "/usr/share//icons/hicolor/16x16/apps/atom.png" },
        {"IntelliJ IDEA", "\"/home/leoliu/Tools/idea/bin/idea.sh\" ", "///home/leoliu/Tools/idea/bin/idea.png" },
        {"RStudio", "/usr/lib/rstudio/bin/rstudio ", "/usr/share//icons/hicolor/16x16/apps/rstudio.png" },
    }},
    {"游戏", {
        {"Mines", "gnome-mines", "/usr/share//icons/hicolor/16x16/apps/gnome-mines.png" },
        {"Sudoku", "gnome-sudoku", "/usr/share//icons/hicolor/16x16/apps/gnome-sudoku.png" },
    }},
    {"系统", {
        {"Fcitx", "fcitx", "/usr/share//icons/hicolor/16x16/apps/fcitx.png" },
        {"GDebi Package Installer", "gdebi-gtk "},
        {"Gigolo 远程连接", "gigolo"},
        {"Guake Terminal", "guake", "/usr/share//icons/hicolor/16x16/apps/guake.png" },
        {"LightDM GTK+ Greeter settings", "lightdm-gtk-greeter-settings-pkexec", "/usr/share//icons/hicolor/16x16/apps/lightdm-gtk-greeter-settings.png" },
        {"Network", "network-admin"},
        {"Printers", "system-config-printer"},
        {"Software Updater", "/usr/bin/update-manager"},
        {"Thunar 文件管理器", "thunar ", "/usr/share//icons/hicolor/16x16/apps/Thunar.png" },
        {"Time and Date", "time-admin", "/usr/share//icons/hicolor/16x16/apps/time-admin.png" },
        {"UXTerm", "uxterm", "/usr/share//icons/hicolor/48x48/apps/xterm-color.png" },
        {"Ubuntu Software Center", "/usr/bin/software-center ", "/usr/share//icons/hicolor/16x16/apps/softwarecenter.svg" },
        {"Users and Groups", "users-admin"},
        {"XTerm", "xterm", "/usr/share//icons/hicolor/48x48/apps/xterm-color.png" },
        {"Xfce 终端", "xfce4-terminal"},
        {"任务管理器", "xfce4-taskmanager"},
        {"批量重命名", "/usr/lib/x86_64-linux-gnu/Thunar/ThunarBulkRename ", "/usr/share//icons/hicolor/16x16/apps/Thunar.png" },
    }},
    {"设置", {
        {"About Me", "/usr/bin/mugshot", "/usr/share//icons/hicolor/16x16/apps/mugshot.svg" },
        {"Additional Drivers", "/usr/bin/software-properties-gtk --open-tab=4"},
        {"Bluetooth Manager", "blueman-manager", "/usr/share//icons/hicolor/16x16/apps/blueman.png" },
        {"Fcitx 配置", "fcitx-configtool", "/usr/share//icons/hicolor/16x16/apps/fcitx.png" },
        {"Guake Preferences", "guake-prefs", "/usr/share//icons/hicolor/16x16/apps/guake-prefs.png" },
        {"Keyboard Input Methods", "ibus-setup"},
        {"Language Support", "/usr/bin/gnome-language-selector"},
        {"LightDM GTK+ Greeter settings", "lightdm-gtk-greeter-settings-pkexec", "/usr/share//icons/hicolor/16x16/apps/lightdm-gtk-greeter-settings.png" },
        {"Menu Editor", "/usr/bin/menulibre", "/usr/share//icons/hicolor/16x16/apps/menulibre.svg" },
        {"Network", "network-admin"},
        {"Network Connections", "nm-connection-editor"},
        {"Onboard Settings", "onboard-settings"},
        {"OpenJDK Java 8 Policy Tool", "/usr/bin/policytool", "/usr/share/pixmaps/openjdk-8.xpm" },
        {"Printers", "system-config-printer"},
        {"Software & Updates", "xdg_menu_su software-properties-gtk", "/usr/share//icons/hicolor/16x16/apps/software-properties.png" },
        {"Software Updater", "/usr/bin/update-manager"},
        {"Theme Configuration", "gtk-theme-config"},
        {"Time and Date", "time-admin", "/usr/share//icons/hicolor/16x16/apps/time-admin.png" },
        {"Ubuntu Software Center", "/usr/bin/software-center ", "/usr/share//icons/hicolor/16x16/apps/softwarecenter.svg" },
        {"Users and Groups", "users-admin"},
        {"可移动驱动器和介质", "thunar-volman-settings"},
        {"文件管理器", "thunar-settings", "/usr/share//icons/gnome/16x16/apps/system-file-manager.png" },
        {"电源管理器", "xfce4-power-manager-settings", "/usr/share//icons/hicolor/16x16/status/xfpm-ac-adapter.png" },
    }},
    {"附件", {
        {"Albert", "albert", "///usr/share/albert/icons/icon.svg" },
        {"Archive Manager", "file-roller ", "/usr/share//icons/hicolor/16x16/apps/file-roller.png" },
        {"Atom", "/opt/atom/atom ", "/usr/share//icons/hicolor/16x16/apps/atom.png" },
        {"Byobu Terminal", (terminal or "xterm") .. " -e env TERM=xterm-256color byobu"},
        {"Calculator", "gnome-calculator"},
        {"Catfish File Search", "catfish"},
        {"Character Map", "gucharmap", "/usr/share//icons/gnome/16x16/apps/accessories-character-map.png" },
        {"DockX", "dockx", "/usr/share//icons/hicolor/16x16/apps/dockbarx.png" },
        {"DockbarX Preference", "dbx_preference", "/usr/share//icons/hicolor/16x16/apps/dockbarx.png" },
        {"Fcitx", "fcitx", "/usr/share//icons/hicolor/16x16/apps/fcitx.png" },
        {"Guake Terminal", "guake", "/usr/share//icons/hicolor/16x16/apps/guake.png" },
        {"LightDM GTK+ Greeter settings", "lightdm-gtk-greeter-settings-pkexec", "/usr/share//icons/hicolor/16x16/apps/lightdm-gtk-greeter-settings.png" },
        {"Menu Editor", "/usr/bin/menulibre", "/usr/share//icons/hicolor/16x16/apps/menulibre.svg" },
        {"Onboard", "onboard"},
        {"Onboard Settings", "onboard-settings"},
        {"Orage 全球时间", "globaltime", "/usr/share//icons/hicolor/48x48/apps/orage_globaltime.png" },
        {"Thunar 文件管理器", "thunar ", "/usr/share//icons/hicolor/16x16/apps/Thunar.png" },
        {"UXTerm", "uxterm", "/usr/share//icons/hicolor/48x48/apps/xterm-color.png" },
        {"Vim", (terminal or "xterm") .. " -e vim "},
        {"XTerm", "xterm", "/usr/share//icons/hicolor/48x48/apps/xterm-color.png" },
        {"Xfburn 刻录程序", "xfburn"},
        {"gedit", "gedit "},
        {"任务管理器", "xfce4-taskmanager"},
        {"小企鹅皮肤配置向导", "/usr/bin/fcitx-qimpanel-configtool", "/usr/share/pixmaps/fcitx_ubuntukylin.png" },
        {"应用程序查找器", "xfce4-appfinder", "/usr/share//icons/gnome/16x16/actions/gtk-find.png" },
        {"截图", "xfce4-screenshooter", "/usr/share//icons/hicolor/48x48/apps/applets-screenshooter.png" },
        {"批量重命名", "/usr/lib/x86_64-linux-gnu/Thunar/ThunarBulkRename ", "/usr/share//icons/hicolor/16x16/apps/Thunar.png" },
    }},
}
end

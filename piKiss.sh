#!/bin/bash
#
# PiKISS (Pi Keeping simple, stupid!)
#
# Author  : Jose Cerrejon Gonzalez
# Mail    : ulysess@gmail_dot_com
# Version : Check VERSION variable
#

. ./scripts/helper.sh || . ../helper.sh || . ./helper.sh || wget -q 'https://github.com/jmcerrejon/PiKISS/raw/master/scripts/helper.sh'
clear
check_board || { echo "Missing file helper.sh. I've tried to download it for you. Try to run the script again." && exit 1; }

VERSION="v.1.8.0"
IP=$(get_ip)
TITLE="PiKISS (Pi Keeping It Simple, Stupid!) ${VERSION} .:. Jose Cerrejon | IP=${IP} ${CPU}| Model=${MODEL}"
CHK_UPDATE=0
CHK_PIKISS_UPDATE=0
NOINTERNETCHECK=0
wHEIGHT=20
wWIDTH=90
check_board
check_temperature
check_CPU
make_desktop_entry
remove_unneeded_helper

usage() {
    echo -e "$TITLE\n\nScript designed to config or install apps on Raspberry Pi easier for everyone.\n"
    echo -e "Usage: ./piKiss.sh [Arguments]\n\nArguments:\n"
    echo "-h   | --help       		: This help."
    echo "-nu  | --no-update  	 	: No check if repositories are updated."
    echo "-nup | --no-update-pikiss : No check if PiKISS are updated."
    echo "-ni  | --noinet     		: No check if internet connection is available."
    echo
    echo "For trouble, ideas or technical support please visit https://github.com/jmcerrejon/PiKISS"
}

#
# Initial checks
#

# Arguments
while [ "$1" != "" ]; do
    case $1 in
    -nu | --no_update)
        export CHK_UPDATE=1
        ;;
    -nup | --no_update-pikiss)
        export CHK_PIKISS_UPDATE=1
        ;;
    -ni | --noinet)
        export NOINTERNETCHECK=1
        ;;
    -h | --help)
        usage
        exit
        ;;
    *)
        usage
        exit 1
        ;;
    esac
    shift
done

is_missing_dialog_pkg
check_internet_available
# last_update_repo # TODO Test this feature
check_update_pikiss

#
# Menu
#
smInfo() {
    cmd=(dialog --clear --backtitle "$TITLE" --title "[ Info ]" --menu "Select an option from the list:" "$wHEIGHT" "$wWIDTH" "$wHEIGHT")

    # common options, working on any model
    options=(
        Back "Back to main menu"
        Weather "Weather info from your country"
        Chkimg "Check some distros images to know if they are updated"
    )
    if [[ ${MODEL} == 'Raspberry Pi' ]]; then
        options+=(
            Webmin "Monitoring tool"
            Bmark "Benchmark RPi (CPU, MEM, SD Card...)"
            Lynis "Lynis is a security auditing tool."
            TestInet "Test Internet bandwidth"
            WebMonitor "Web monitor to your RPi"
        )
    fi

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices; do
        case $choice in
        Back) break ;;
        Chkimg) ./scripts/info/check_lastmod_img.sh ;;
        Webmin) ./scripts/info/webmin.sh ;;
        Weather) ./scripts/info/weather.sh ;;
        Bmark) ./scripts/info/bmark.sh ;;
        Lynis) ./scripts/info/lynis.sh ;;
        TestInet) ./scripts/info/test_inet.sh ;;
        WebMonitor) ./scripts/info/web_monitor.sh ;;
        esac
    done
}

smTweaks() {
    cmd=(dialog --clear --backtitle "$TITLE" --title "[ Tweaks ]" --menu "Select a tweak from the list:" "$wHEIGHT" "$wWIDTH" "$wHEIGHT")

    if [[ ${MODEL} == 'Raspberry Pi' ]]; then
        options=(
            Back "Back to main menu"
            # Autologin "Set autologin for the pi user"
            Others "CPU performance, disable Ethernet and so on"
            Packages "Programs you don't use (maybe) to free space"
            Daemons "Disable useless services"
            ZRAM "Enable/Disable ZRAM"
        )
    fi

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices; do
        case $choice in
        Back) break ;;
        Autologin) ./scripts/tweaks/autologin.sh ;;
        Others) ./scripts/tweaks/others.sh ;;
        Packages) ./scripts/tweaks/removepkg.sh ;;
        Daemons) ./scripts/tweaks/services.sh ;;
        ZRAM) ./scripts/tweaks/zram.sh ;;
        esac
    done
}

smGames() {
    cmd=(dialog --clear --backtitle "$TITLE" --title "[ Games ]" --menu "Select game from the list:" "$wHEIGHT" "$wWIDTH" "$wHEIGHT")

    if [[ ${MODEL} == 'Raspberry Pi' ]]; then
        options=(
            Back "Back to main menu"
            Abbaye "L’Abbaye des Morts is a retro puzzle platformer by Locomalito"
            AVP "Aliens versus Predator is a 1999 SF fps published by Fox Interactive"
            Arx "Arx Fatalis is a fps RPG set on a world whose sun has failed"
            Blood "Blood is a fps game developed by Monolith Productions"
            BStone "Robert W. Stone III, AKA Blake Stone must eliminate Dr. Pyrus Goldfire"
            CaptainS "Save Seville from the evil Torrebruno"
            Doom_engine "Zendronum or Crispy engine to play Doom, Heretic, Hexen..."
            Descent "Descent 1 & 2 Shareware Ed."
            Dune2 "Dune 2 Legacy"
            Diablo "Take control of a lone hero battling to rid the world of Diablo"
            Diablo2 "Diablo 2 Lord of Destruction"
            Eduke32 "Duke Nukem 3D is a fps game developed by 3D Realms"
            GTA "GTA III/Vice City are open worlds video games part of the GTA franchise"
            GemRB "Engine for games like Baldur's Gate"
            HalfLife "Gordon Freeman must exit Black Mesa after it's invaded by aliens"
            Heroes2 "Free implementation of Heroes of Might and Magic II engine"
            Heroes3 "Open-source engine for Heroes of Might and Magic III"
            Hermes "Jump'n' Run game with plenty of bad taste humour."
            Hurrican "Jump and shoot game based on the Turrican game series"
            Morrowind "The Elder Scrolls III: Morrowind is an open-world RPG"
            OpenBor "OpenBOR is the open source continuation of Beats of Rage"
            OpenClaw "Platform 2D Captain Claw (1997) reimplementation"
            OpenSPlex "OpenSupaplex reimplementation of the original 90's game"
            OpenXCom "Open-source clone of UFO: Enemy Unknown"
            Prince "port/conversion of the DOS game Prince of Persia"
            Quake "Enhanced clients for ID Software's Quake saga"
            ReturnC "The dark reich's closing in. The time to act is now"
            Revolt "Re-Volt is a radio control car racing themed video game"
            SMario64 "Super Mario 64 EX native OpenGL ES"
            SpelunkyHD "Spelunky is a cave exploration/treasure-hunting game"
            Sqrxz4 "Sqrxz 4: Difficult platform game"
            SSam12 "Serious Sam I & II. Kill all walking monster"
            StarCraft "Expansion pack for the real-time strategy video game StarCraft"
            StepMania "StepMania is a free dance and rhythm game"
            Temptations "Platform game made exclusively for MSX computers"
            VVVVVV "Minimalist platformer: instead of jumping, you need to reverse gravity"
            Xump "Xump: Simple multi-platform puzzler"
        )
    fi

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices; do
        case $choice in
        Back) break ;;
        Abbaye) ./scripts/games/abbaye.sh ;;
        AVP) ./scripts/games/avp.sh ;;
        Arx) ./scripts/games/arx.sh ;;
        Blood) ./scripts/games/blood.sh ;;
        BStone) ./scripts/games/bstone.sh ;;
        CaptainS) ./scripts/games/captains.sh ;;
        Doom_engine) ./scripts/games/cdoom.sh ;;
        Descent) ./scripts/games/descent.sh ;;
        Dune2) ./scripts/games/dune2.sh ;;
        Diablo) ./scripts/games/diablo.sh ;;
        Diablo2) ./scripts/games/diablo2.sh ;;
        Eduke32) ./scripts/games/eduke32.sh ;;
        GTA) ./scripts/games/gta.sh ;;
        GemRB) ./scripts/games/gemrb.sh ;;
        HalfLife) ./scripts/games/half-life.sh ;;
        Heroes2) ./scripts/games/heroes2.sh ;;
        Heroes3) ./scripts/games/heroes3.sh ;;
        Hermes) ./scripts/games/hermes.sh ;;
        Hurrican) ./scripts/games/hurrican.sh ;;
        Morrowind) ./scripts/games/openmw.sh ;;
        OpenBor) ./scripts/games/openbor.sh ;;
        OpenClaw) ./scripts/games/openclaw.sh ;;
        OpenSPlex) ./scripts/games/supaplex.sh ;;
        OpenXCom) ./scripts/games/openxcom.sh ;;
        Prince) ./scripts/games/princeofp.sh ;;
        Quake) ./scripts/games/quake.sh ;;
        ReturnC) ./scripts/games/rwolf.sh ;;
        Revolt) ./scripts/games/revolt.sh ;;
        SMario64) ./scripts/games/smario64.sh ;;
        SpelunkyHD) ./scripts/games/spelunky.sh ;;
        Sqrxz4) ./scripts/games/sqrxz4.sh ;;
        SSam12) ./scripts/games/ssam.sh ;;
        StarCraft) ./scripts/games/starcraft.sh ;;
        StepMania) ./scripts/games/stepmania.sh ;;
        Temptations) ./scripts/games/temptations.sh ;;
        VVVVVV) ./scripts/games/vvvvvv.sh ;;
        Xump) ./scripts/games/xump.sh ;;
        esac
    done
}

smEmulators() {
    cmd=(dialog --clear --backtitle "$TITLE" --title "[ Emulators ]" --menu "Select emulator from the list:" "$wHEIGHT" "$wWIDTH" "$wHEIGHT")

    if [[ ${MODEL} == 'Raspberry Pi' ]]; then
        options=(
            Back "Back to main menu"
            Amiga "Amiberry is the best Amiga emulator"
            Box86 "Lets you run x86 Linux programs on non-x86 Linux"
            Comm64 "VICE is a Commodore 64 emulator"
            Dolphin "Dolphin is a Wii & Gamecube emulator (EXPERIMENTAL)"
            Amstrad "Amstrad CPC with Caprice32"
            MSDOS "DOSBox-X is a DOS emulator with GUI"
            Gba "Gameboy Advance (mgba)"
            Genesis "Genesis Megadrive Emulator (picodrive)"
            Mednafen "Portable multi-system emulator (Mednafen)"
            Mame "Install MAME 0.230, Advance MAME or MAME4ALL-PI"
            MSX "OpenMSX"
            NES "Nestopia UE is an accurate NES emulator"
            Pifba "Emulates old arcade games using CPS1, CPS2,..."
            PS1 "DuckStation - PlayStation 1, aka. PSX Emulator"
            PSP "PPSSPP can run your PSP games on your RPi in full HD resolution"
            ResidualVM "Cross-platform 3D game interpreter to play some games"
            RetroArch "Open source frontend for emulators & game/video engines"
            Redream "Redream is a Dreamcast emulator"
            ScummVM "Allow gamers to play point-and-click adventure games"
            Snes "SNES Emulator Snes9X or Bsnes"
            ZX-Spectrum "Speccy is a ZX-Spectrum emulator"
        )
    fi

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices; do
        case $choice in
        Back) break ;;
        Amiga) ./scripts/emus/amiga.sh ;;
        Box86) ./scripts/emus/box86.sh ;;
        Amstrad) ./scripts/emus/caprice.sh ;;
        Comm64) ./scripts/emus/commodore.sh ;;
        Dolphin) ./scripts/emus/dolphin.sh ;;
        MSDOS) ./scripts/emus/msdos.sh ;;
        Gba) ./scripts/emus/gba.sh ;;
        Genesis) ./scripts/emus/genesis.sh ;;
        Mednafen) ./scripts/emus/mednafen.sh ;;
        Mame) ./scripts/emus/mame4allpi.sh ;;
        MSX) ./scripts/emus/msx.sh ;;
        NES) ./scripts/emus/nes.sh ;;
        PS1) ./scripts/emus/psx.sh ;;
        PSP) ./scripts/emus/psp.sh ;;
        Pifba) ./scripts/emus/pifba.sh ;;
        ResidualVM) ./scripts/emus/residual.sh ;;
        RetroArch) ./scripts/emus/retroarch.sh ;;
        Redream) ./scripts/emus/dc.sh ;;
        ScummVM) ./scripts/emus/scummvm.sh ;;
        Snes) ./scripts/emus/snes.sh ;;
        ZX-Spectrum) ./scripts/emus/speccy.sh ;;
        esac
    done
}

smMultimedia() {
    cmd=(dialog --clear --backtitle "$TITLE" --title "[ Multimedia ]" --menu "Select a script from the list:" "$wHEIGHT" "$wWIDTH" "$wHEIGHT")

    if [[ ${MODEL} == 'Raspberry Pi' ]]; then
        options=(
            Back "Back to main menu"
            JELLYFIN "Stream media to any device from your own server"
            Kodi "Kodi is a free media player that is designed to look great on your TV but is just as home on a small screen."
            Kiosk "Image slideshow"
            Moonlight "Moonlight PC is an open source implementation of NVIDIA's GameStream"
            OBS "Free & open source software 4 video recording and streaming"
        )
    fi

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices; do
        case $choice in
        Back) break ;;
        JELLYFIN) ./scripts/mmedia/jellyfin.sh ;;
        Kodi) ./scripts/mmedia/xbmc.sh ;;
        Kiosk) ./scripts/mmedia/kiosk.sh ;;
        Moonlight) ./scripts/mmedia/moonlight-qt.sh ;;
        OBS) ./scripts/mmedia/obs.sh ;;
        esac
    done
}

smConfigure() {
    cmd=(dialog --clear --backtitle "$TITLE" --title "[ Configure ]" --menu "Select to configure your distro:" "$wHEIGHT" "$wWIDTH" "$wHEIGHT")

    if [[ ${MODEL} == 'Raspberry Pi' ]]; then
        options=(
            Back "Back to main menu"
            Vulkan "Compile/update Vulkan Mesa driver"
            RaspNet "Configure Raspbian Net Install distro"
            SSIDCfg "Configure SSID (WPA/WPA2 with PSK)"
            Joypad "Configure WII, XBox360 controller"
            Backup "Simple backup dir to run daily"
            # Applekeyb "Bluetooth keyboard"
            Netcfg "Configure static IP"
            Monitorcfg "Configure your TV resolution"
        )
    elif [[ ${MODEL} == 'ODROID-C1' ]]; then
        options=(
            Back "Back to main menu"
        )
    fi

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices; do
        case $choice in
        Back) break ;;
        Vulkan) ./scripts/config/vulkan.sh ;;
        RaspNet) ./scripts/config/raspnetins.sh ;;
        SSIDCfg) ./scripts/config/ssidcfg.sh ;;
        Joypad) ./scripts/config/jpad.sh ;;
        Backup) ./scripts/config/backup.sh ;;
        Applekeyb) ./scripts/config/applekeyb.sh ;;
        Netcfg) ./scripts/config/netconfig.sh ;;
        Monitorcfg) ./scripts/config/monitorcfg.sh ;;
        esac
    done
}

smInternet() {
    cmd=(dialog --clear --backtitle "$TITLE" --title "[ Internet ]" --menu "Select an option from the list:" "$wHEIGHT" "$wWIDTH" "$wHEIGHT")

    if [[ ${MODEL} == 'Raspberry Pi' ]]; then
        options=(
            Back "Back to main menu"
            SyncTERM "BBS terminal program"
            Whatscli "Allow users to use WhatsApp via cli"
            Zoom "i386 version of software platform used for teleconferencing using Box86"
            # Plowshare "Direct download from hosters like uploaded,..."
            # Browser "Web browser"
            # Downmp3 "Download mp3 from GrooveShark"
        )
    fi

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices; do
        case $choice in
        Back) break ;;
        SyncTERM) ./scripts/inet/syncterm.sh ;;
        Plowshare) ./scripts/inet/ddown.sh ;;
        Browser) ./scripts/inet/browser.sh ;;
        Downmp3) ./scripts/inet/dwnmp3.sh ;;
        Whatscli) ./scripts/inet/whatscli.sh ;;
        Zoom) ./scripts/inet/zoom.sh ;;
        esac
    done
}

smServer() {
    cmd=(dialog --clear --backtitle "$TITLE" --title "[ Server ]" --menu "Select to configure your distro as a server:" "$wHEIGHT" "$wWIDTH" "$wHEIGHT")

    if [[ ${MODEL} == 'Raspberry Pi' ]]; then
        options=(
            Back "Back to main menu"
            AdBlock "Turn Raspberry Pi into an Ad blocker with Pi-Hole"
            Cups "Printer server (cups)"
            DB "MySQL+PHP5 connector"
            FTP "Simple FTP Server with vsftpd"
            FWork "WordPress, Node.js among others"
            GitServer "Use your RPi as a Git Server"
            Jenkins "Jenkins is a free and open source automation server"
            Minidlna "Install/Compile UPnP/DLNA Minidlna"
            Nagios "Nagios is a network host and service monitoring"
            OctoPrint "Control your 3D-Printer"
            OwnCloud "Access your data from all your devices"
            RDesktop "Connect to your Raspberry Pi throught VNC,..."
            Smtp "SMTP Config to send e-mail"
            SMB "Share files with SAMBA"
            Upd "keep Debian patched with latest security updates"
            VPNServer "OpenVPN setup and config thanks to pivpn.io"
            Web "Web server+PHP7"
            WebDAV "WebDAV to share local content with Apache"
        )
    fi

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices; do
        case $choice in
        Back) break ;;
        AdBlock) ./scripts/server/adblock.sh ;;
        Cups) ./scripts/server/printer.sh ;;
        DB) ./scripts/server/db.sh ;;
        FTP) ./scripts/server/ftp.sh ;;
        FWork) ./scripts/server/fwork.sh ;;
        GitServer) ./scripts/server/gitserver.sh ;;
        Jenkins) ./scripts/server/jenkins.sh ;;
        Minidlna) ./scripts/server/mediaserver.sh ;;
        Nagios) ./scripts/server/nagios.sh ;;
        OctoPrint) ./scripts/server/octoprint.sh ;;
        OwnCloud) ./scripts/server/owncloud.sh ;;
        RDesktop) ./scripts/server/rdesktop.sh ;;
        Smtp) ./scripts/server/smtp.sh ;;
        SMB) ./scripts/server/fileserver.sh ;;
        Upd) ./scripts/server/auto-upd.sh ;;
        VPNServer) ./scripts/server/openvpn.sh ;;
        Web) ./scripts/server/web.sh ;;
        WebDAV) ./scripts/server/webdav.sh ;;
        esac
    done
}

smDevs() {
    cmd=(dialog --clear --backtitle "$TITLE" --title "[ Developers ]" --menu "Select to configure some apps for development:" "$wHEIGHT" "$wWIDTH" "$wHEIGHT")

    # options working on any board
    options=(
        Back "Back to main menu"
        QT5 "Free and open-source widget toolkit for creating graphical UI cross-platform applications"
        TIC80 "TIC-80 is a free fantasy computer for making, playing tiny games"
        VSCode/ium "Lightweight but powerful source code editor which runs on your desktop"
    )

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices; do
        case $choice in
        Back) break ;;
        QT5) ./scripts/devs/qt5.sh ;;
        TIC80) ./scripts/devs/tic-80.sh ;;
        VSCode/ium) ./scripts/devs/vscode.sh ;;
        esac
    done
}

smOthers() {
    cmd=(dialog --clear --backtitle "$TITLE" --title "[ Others ]" --menu "Another scripts uncategorized:" "$wHEIGHT" "$wWIDTH" "$wHEIGHT")

    if [[ ${MODEL} == 'Raspberry Pi' ]]; then
        options=(
            Back "Back to main menu"
            Aircrack "Compile Aircrack-NG suite easily"
            Alacritty "Fastest terminal emulator using GPU for rendering and Wayland compatible"
            BootLoader "Update your RPi boot loader"
            CoolTerm "Compile a terminal with the look and feel of the old cathode tube screens"
            Fixes "Fix some problems with the Raspbian OS"
            GL4ES "Compile GL4ES - OpenGL for GLES Hardware"
            NetTools "MITM Pentesting Opensource Toolkit (Require X)"
            Part "Check issues & fix SD corruptions"
            RPiPlay "An open-source implementation of an AirPlay mirroring server"
            Scrcpy "Display and control of Android devices connected on USB"
            SDL2 "Compile/Install SDL2 + Libraries"
            ShaderToy "Render over 100+ OpenGL ES 3.0 shaders"
            Synergy "Allow you to share keyboard and mouse to computers on LAN"
            Uninstall "Uninstall PiKISS :_("
            WineX86 "Install Wine X86 + Box86"
        )
    fi

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices; do
        case $choice in
        Back) break ;;
        Aircrack) ./scripts/others/aircrack.sh ;;
        Alacritty) ./scripts/others/alacritty.sh ;;
        BootLoader) ./scripts/others/update-bootloader.sh ;;
        CoolTerm) ./scripts/others/retro-term.sh ;;
        Fixes) ./scripts/others/fixes.sh ;;
        GL4ES) ./scripts/others/gl4es.sh ;;
        NetTools) ./scripts/others/nettools.sh ;;
        Part) ./scripts/others/checkpart.sh ;;
        RPiPlay) ./scripts/others/rpiplay.sh ;;
        Scrcpy) ./scripts/others/scrcpy.sh ;;
        SDL2) ./scripts/others/sdl2.sh ;;
        ShaderToy) ./scripts/others/shadertoy.sh ;;
        Synergy) ./scripts/others/synergy.sh ;;
        Uninstall) uninstall_pikiss ;;
        WineX86) ./scripts/others/wine86.sh ;;
        esac
    done
}

#
# Main menu
#
while true; do
    cmd=(dialog --clear --backtitle "$TITLE" --title " [ M A I N - M E N U ] " --menu "You can use the UP/DOWN arrow keys, the first letter of the choice as a hot key, or the number keys 1-9 to choose an option:" "$wHEIGHT" "$wWIDTH" "$wHEIGHT")

    options=(
        Tweaks "Push your distro to the limit"
        Games "Install or compile games easily"
        Emulation "Install emulators"
        Info "Info about the Pi or related"
        Multimedia "Install apps like XBMC"
        Configure "Installations are piece of cake now"
        Internet "Tweaks related to internet"
        Server "Use your distro as a server"
        Devs "Tools for making your own apps"
        Others "Scripts with others thematics"
        Exit "Exit to the shell"
    )

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    for choice in $choices; do
        case $choice in
        Tweaks) smTweaks ;;
        Games) smGames ;;
        Emulation) smEmulators ;;
        Info) smInfo ;;
        Multimedia) smMultimedia ;;
        Configure) smConfigure ;;
        Internet) smInternet ;;
        Server) smServer ;;
        Devs) smDevs ;;
        Others) smOthers ;;
        Exit) clear && exit_pikiss ;;
        1)
            echo -e "\nCancel pressed." && exit
            ;;
        255)
            echo -e "\nESC pressed." && exit
            ;;
        esac
    done
done

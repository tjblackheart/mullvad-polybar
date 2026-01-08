#!/usr/bin/env bash

ICON_CONNECTED=""
ICON_DISCONNECTED=""
COLOR_CONNECTED="#a5fb8f"
COLOR_CONNECTING="#707880"
COLOR_DISCONNECTED="#fc3542"
REMOTE_IP="ip.subdev.org"
NOTIFY_ICON="/usr/share/icons/hicolor/32x32/apps/mullvad-vpn.png"

# 2026-01
declare -A countries=(
    ["Albania"]=AL
    ["Argentina"]=AR
    ["Australia"]=AU
    ["Austria"]=AT
    ["Belgium"]=BE
    ["Brazil"]=BR
    ["Bulgaria"]=BG
    ["Canada"]=CA
    ["Chile"]=CL
    ["Colombia"]=CO
    ["Croatia"]=HR
    ["Cyprus"]=CY
    ["Czech Republic"]=CZ
    ["Denmark"]=DK
    ["Estonia"]=EE
    ["Finland"]=FI
    ["France"]=FR
    ["Germany"]=DE
    ["Greece"]=GR
    ["Hong Kong"]=HK
    ["Hungary"]=HU
    ["Indonesia"]=ID
    ["Ireland"]=IE
    ["Israel"]=IL
    ["Italy"]=IT
    ["Japan"]=JP
    ["Malaysia"]=MY
    ["Mexico"]=MX
    ["Netherlands"]=NL
    ["New Zealand"]=NZ
    ["Nigeria"]=NG
    ["Norway"]=NO
    ["Peru"]=PE
    ["Philippines"]=PH
    ["Poland"]=PL
    ["Portugal"]=PT
    ["Romania"]=RO
    ["Serbia"]=RS
    ["Singapore"]=SG
    ["Slovakia"]=SK
    ["Slovenia"]=SI
    ["South Africa"]=ZA
    ["Spain"]=ES
    ["Sweden"]=SE
    ["Switzerland"]=CH
    ["Thailand"]=TH
    ["Turkey"]=TR
    ["UK"]=GB
    ["Ukraine"]=UA
    ["USA"]=US
)

notify() { notify-send "$1" --icon "$NOTIFY_ICON"; }

status() { mullvad status | grep -Eio 'connected|connecting|disconnected' | tr '[:upper:]' '[:lower:]'; }

# get ip directly from relay. won't work if not connected.
# ip() { mullvad status -v | head -n 1 | awk '{print $4}' | grep -Eo '[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+'; }

ip() { curl -sfL "$REMOTE_IP"; }

copy() { ip | xclip -selection clipboard; }

city() { mullvad status -v | head -n 1 | awk '{print $6}' | tr ',' ' ' | xargs; }

country() { mullvad status -v | head -n 1 | awk '{print $7}'; }

short() { [[ $(status) == "connected" ]] && echo "${countries[$(country)]}"; }

info() { [[ $(status) == "connected" ]] && echo "Connected to $(city), $(country) ($(ip))"; }

location(){
    mullvad relay set location "$1"; sleep 1
    if [ "$(status)" == "connected" ]; then notify "$(info)";
    else notify "Relay location changed to $1"; fi
}

toggle() {
    if [[ $(status) == "connected" ]]; then
        mullvad disconnect; sleep 1
        notify "VPN disconnected."
    else
        mullvad connect; sleep 1
        notify "$(info)"
    fi
}

fmt() {
    case "$(status)" in
        "connected") echo "%{F$COLOR_CONNECTED}${ICON_CONNECTED} $(short)%{F-}";;
        "connecting") echo "%{F$COLOR_CONNECTING}${ICON_CONNECTED} ??%{F-}";;
        *) echo "%{F$COLOR_DISCONNECTED}$ICON_DISCONNECTED%{F-}";;
    esac
}

menu() {
    [[ $(command -v rofi) ]] || return

    local title="ﱾ Switch VPN relay"
    local icon="⚑"
    local entries=""

    for name in "${!countries[@]}"; do
        entries+="$icon $name|"
    done

    selection=$(rofi -location 3 -xoffset 20 -yoffset +38 -sep "|" -dmenu -i -p "$title" <<< "$entries")
    [[ "$selection" == "" ]] && return

    name="${selection/$icon /}"
    code="${countries[$name]}"
    location "$code"
}

###

case "$1" in
    "toggle") toggle;;
    "ip") copy;;
    "menu") menu;;
    "info") info;;
    *) fmt;;
esac

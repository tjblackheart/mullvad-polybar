# mullvad-polybar

A small script to add a one click solution to your polybar when you are a (Mullvad)[https://mullvad.net] user. Heavily inspired by [shervinsahba/polybar-vpn-controller](https://github.com/shervinsahba/polybar-vpn-controller), but I rewrote this to remove unnecessary stuff and to have a cleaned up version. Thanks for the inspiration!

## Usage

Left click: connect/disconnect
Right click: Select relay
Middle click: Copy IP

See [shervinsahba/polybar-vpn-controller](https://github.com/shervinsahba/polybar-vpn-controller).

## Installation

Add to your polybar config:

```bash
[module/mullvad]
type = custom/script
exec = $HOME/.config/polybar/vpn/mullvad.sh
click-left = $HOME/.config/polybar/vpn/mullvad.sh toggle
click-middle = $HOME/.config/polybar/vpn/mullvad.sh ip
click-right = $HOME/.config/polybar/vpn/mullvad.sh menu
interval = 1
format = <label>
```

Then add it where you want it:

`modules-right = pulseaudio memory cpu mullvad`


## Requirements:

* (ROFI)[https://github.com/davatorium/rofi]
* (Polybar)[https://github.com/polybar/polybar]
* (Mullvad client)[https://mullvad.net/en/download/linux/]

Date: 20.12.2021 Version: 1.0.7 - 20211220
# Power-On-OFF Button for Raspberry Pi (especially used in Phoniebox)

## One-Line Installer.

```
cd; rm powerbutton_install.sh; wget https://raw.githubusercontent.com/PM84/raspberry_pi_power_on_off/main/powerbutton_install.sh; chmod +x powerbutton_install.sh; ./powerbutton_install.sh; rm powerbutton_install.sh;
```

## Usage

Connect an arcade button to GPIO3 and a GND pin.

Use the one line installer.

Press the button at least 2 seconds to shut the pi down.

Press the button again will start the raspberry pi immediately.

## Material
1x Arcade Button (e.g. https://amzn.to/326GRXv)
2x Jumper Wire (F2F - Female to Female; e.g. https://amzn.to/32eEJgb)

## Soldering
Cut off one end of each cable.

Thread in the heat shrink tubing.

Solder the cut end to the button.

Slide the heat shrink tubing over the soldered joint and shrink it.

pactl set-default-sink "alsa_output.usb-Plantronics_Plantronics_Blackwire_5220_Series_46CA081846874D4B8B5FED55D03B96F4-00.analog-stereo"
pactl set-default-sink "alsa_output.pci-0000_00_1f.3.analog-stereo"

bluetoothctl connect 84:D3:52:81:CC:8E
pactl set-default-sink "bluez_output.84_D3_52_81_CC_8E.1"

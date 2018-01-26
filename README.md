OSMC_GPIO
---
![screen0](https://github.com/rern/_assets/blob/master/OSMC_GPIO/kodigpio.jpg)  

**Features**
- Power `on` `off` audio equipments in sequence
- delay setting for each equipment(relay)
- Notification for `on` `off`
- Idle timer power off by polling 'play' status every minute with last minute warning
- Auto power off on reboot / shutdown

**Install**
```sh
wget -qN --show-progress https://github.com/rern/OSMC/raw/master/OSMC_GPIO/install.sh; chmod +x install.sh; ./install.sh
```

**Settings**  
Edit: `/home/osmc/gpio.json`  

**Control**  
- Keyboard / Remote control: add the following to on / off buttons in `keyboard.xml` / `remote.xml`  
```xml
<key1>RunScript(/home/osmc/gpioon.py)</key1>
<key2>RunScript(/home/osmc/gpiooff.py)</key2>
```

![remote](https://github.com/rern/_assets/blob/master/OSMC_GPIO/usb_pc_remote_button_code.jpg)  

- Menu: add the following to `DialogButtonMenu.xml` in skin directory  
```xml
<!-- within <content> ... </content> -->
	<item>
		<label>GPIO On</label>
		<onclick>RunScript(/home/osmc/gpioon.py)</onclick>
		<visible>System.CanReboot</visible>
	</item>
	<item>
		<label>GPIO Off</label>
		<onclick>RunScript(/home/osmc/gpiooff.py)</onclick>
		<visible>System.CanReboot</visible>
	</item>
```

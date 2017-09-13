#!/bin/bash

# install.sh - run as root

rm $0

# import heading function
wget -qN --show-progress https://github.com/rern/title_script/raw/master/title.sh; . title.sh; rm title.sh
timestart

osmcgpio=$( tcolor "OSMC GPIO" )

# check installed #######################################
if [[ -e /usr/local/bin/uninstall_gpio.sh ]]; then
	echo -e "$info $osmcgpio already installed"
	exit
fi

title -l = "$bar Install $osmcgpio ..."

# install packages #######################################
# skip with any argument
if (( $# == 0 )); then
	echo -e "$bar Update package databases ..."
	apt update
fi
if ! dpkg -s python-pip 2>/dev/null | grep -q 'Status: install ok installed'; then
	echo -e "$bar Install Python-Pip ..."
	apt install -y python-pip
fi
if ! dpkg -s python-dev 2>/dev/null | grep -q 'Status: install ok installed'; then
	echo -e "$bar Install Python-Dev ..."
	apt install -y python-dev
fi
if ! type gcc &>/dev/null; then
	echo -e "$bar Install GCC ..."
	apt install -y gcc
fi
if ! type bsdtar &>/dev/null; then
	echo -e "$bar Install bsdtar ..."
	apt install -y bsdtar
fi

if ! python -c "import RPi.GPIO" &>/dev/null; then
	echo -e "$bar Install Python-RPi.GPIO ..."
	yes | pip install RPi.GPIO
fi

# install OSMC GPIO #######################################
echo -e "$bar Get files ..."
wgetnc https://github.com/rern/OSMC_GPIO/archive/master.zip

echo -e "$bar Install new files ..."
rm -rf /tmp/install
mkdir -p /tmp/install
bsdtar -xf master.zip --strip 1 --exclude '_repo/' -C /tmp/install
rm master.zip /tmp/install/{.*,*.md,install.sh} &> /dev/null
[[ -e /home/osmc/gpio.json ]] && rm /tmp/install/home/osmc/gpio.json

chown -R root:root /tmp/install
chmod -R 755 /tmp/install

cp -rp /tmp/install/* /
rm -r /tmp/install

udevadm control --reload

# set initial gpio #######################################
echo -e "$bar GPIO service ..."
systemctl daemon-reload
systemctl enable gpioset
systemctl start gpioset

# set permission #######################################
#echo 'osmc ALL=NOPASSWD: ALL' > /etc/sudoers.d/osmc # already set
usermod -a -G root osmc # add user osmc to group root to allow /dev/gpiomem access
#chmod g+rw /dev/gpiomem # allow group to access set in gpioset.py for every boot

# modify shutdown menu #######################################
file=/usr/share/kodi/addons/skin.osmc/16x9/DialogButtonMenu.xml
if ! grep -q 'gpioon.py' $file; then
sed -i -e '/<content>/ a\
\t\t\t\t\t<item>\
\t\t\t\t\t\t<label>GPIO On</label>\
\t\t\t\t\t\t<onclick>RunScript(/home/osmc/gpioon.py)</onclick>\
\t\t\t\t\t\t<onclick>dialog.close(all,true)</onclick>\
\t\t\t\t\t</item>\
\t\t\t\t\t<item>\
\t\t\t\t\t\t<label>GPIO Off</label>\
\t\t\t\t\t\t<onclick>RunScript(/home/osmc/gpiooff.py)</onclick>\
\t\t\t\t\t\t<onclick>dialog.close(all,true)</onclick>\
\t\t\t\t\t</item>
' -e 's|XBMC.Powerdown()|RunScript(/home/osmc/poweroff.py)|
' -e 's|XBMC.Reset()|RunScript(/home/osmc/reboot.py)|
' $file
fi

if [[ -e /home/osmc/rebootosmc.py ]]; then
sed -i '/import os/ i\
import gpiooff
' /home/osmc/rebootosmc.py
sed -i '/import os/ i\
import gpiooff
' /home/osmc/rebootrune.py
fi

timestop
title -l = "$bar $osmcgpio installed successfully."
echo 'Uninstall: uninstall_gpio.sh'
echo
echo 'Setting: edit /home/osmc/gpio.json'
title -nt 'Power menu > GPIO On / GPIO Off'

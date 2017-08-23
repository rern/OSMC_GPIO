#!/bin/bash

# import heading function
wget -qN https://raw.githubusercontent.com/rern/title_script/master/title.sh; . title.sh; rm title.sh
osmcgpio=$( tcolor "OSMC GPIO" )

# check installed #######################################
if [ ! -e /home/osmc/gpioon.py ]; then
	echo -e "$info $osmcgpio not found."
	exit
fi

# gpio off #######################################
/home/osmc/gpiooff.py &>/dev/null &

title -l = "$bar Uninstall $osmcgpio ..."

echo -e "$bar Installed packages"
yesno "Uninstall Python-Pip, Python-Dev, GCC, bsdtar and RPi.GPIO:" answer
if [[ $answer == 1 ]]; then
	echo -e "$bar Uninstall packages ..."
	python -c "import RPi.GPIO" &>/dev/null && pip uninstall -y RPi.GPIO
	dpkg -s bsdtar | grep -q 'Status: install ok installed' && apt remove --purge --auto-remove -y bsdtar
	dpkg -s gcc | grep -q 'Status: install ok installed' && apt remove --purge --auto-remove -y gcc
	dpkg -s python-dev | grep -q 'Status: install ok installed' && apt remove --purge --auto-remove -y python-dev
	dpkg -s python-pip | grep -q 'Status: install ok installed' && apt remove --purge --auto-remove -y python-pip
fi

echo -e "$bar Remove service ..."
systemctl disable gpioset
systemctl daemon-reload

# remove files
echo -e "$bar Remove files ..."
rm -v /home/osmc/{gpiooff.py,gpioon.py,gpioset.py,gpiotimer.py,poweroff.py,reboot.py}
rm -v /etc/systemd/system/gpioset.service

# modify shutdown menu #######################################
file='/usr/share/kodi/addons/skin.osmc/16x9/DialogButtonMenu.xml'
linenum=$( sed -n '/gpioon/=' $file )
sed -i -e "$(( $linenum - 2 )), $(( $linenum + 7 )) d
" -e 's|RunScript(/home/osmc/poweroff.py)|XBMC.Powerdown()|
' -e 's|RunScript(/home/osmc/reboot.py)|XBMC.Reset()|
' $file

sed -i '/import gpiooff/ d' /home/osmc/rebootosmc.py
sed -i '/import gpiooff/ d' /home/osmc/rebootrune.py

gpasswd -d osmc root

title -l = "$bar $osmcgpio uninstalled successfully."

rm $0

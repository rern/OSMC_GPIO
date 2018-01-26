#!/usr/bin/python
import gpio
import os
import sys

if GPIO.input(offx[1]) == 1:
	if len(sys.argv) == 1: # bypass on shutdown/reboot (with any argument) 
		os.system('/usr/bin/xbmc-send -a "Notification(GPIO,Already OFF)"')

else:
	import time

	if off1 != 0:
		GPIO.output(off1, OFF)
	if off2 != 0:
		time.sleep(offd1)
		GPIO.output(off2, OFF)
	if off3 != 0:
		time.sleep(offd2)
		GPIO.output(off3, OFF)
	if off4 != 0:
		time.sleep(offd3)
		GPIO.output(off4, OFF)
	
	os.system('/usr/bin/sudo /usr/bin/pkill -9 gpiotimer.py &')

#!/usr/bin/python
from gpio import *

if GPIO.input( offx[ 1 ] ) == 1 and len( sys.argv ) == 1: # bypass on shutdown/reboot (with any argument)
	os.system( '/usr/bin/xbmc-send -a "Notification(GPIO,Already OFF)"' )
	exit()

if off1 != 0:
	GPIO.output( off1, OFF )
if off2 != 0:
	time.sleep( offd1 )
	GPIO.output( off2, OFF )
if off3 != 0:
	time.sleep( offd2 )
	GPIO.output( off3, OFF )
if off4 != 0:
	time.sleep( offd3 )
	GPIO.output( off4, OFF )

os.system( '/usr/bin/sudo /usr/bin/pkill -9 gpiotimer.py &' )

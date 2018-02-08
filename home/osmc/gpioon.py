#!/usr/bin/python
from gpio import *

if GPIO.input( onx[ 1 ] )  == 0:
	os.system( '/usr/bin/xbmc-send -a "Notification(GPIO,Already ON)"' )
	exit()

if on1 != 0:
	GPIO.output( on1, ON )
if on2 != 0:
	time.sleep( ond1 )
	GPIO.output( on2, ON )
if on3 != 0:
	time.sleep( ond2 )
	GPIO.output( on3, ON )
if on4 != 0:
	time.sleep( ond3 )
	GPIO.output( on4, ON )

os.system( '/usr/bin/sudo /home/osmc/gpiotimer.py &' )

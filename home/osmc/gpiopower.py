#!/usr/bin/python
import gpiooff
import sys
import os

if len( sys.argv ) == 1:
	os.system( '/usr/bin/xbmc-send -a "Shutdown"' )
	exit()
	
os.system( '/usr/bin/reboot '+ sys.argv[ 1 ] )

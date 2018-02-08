#!/usr/bin/python
from gpiooff import *

if len( sys.argv ) == 1:
	os.system( '/usr/bin/xbmc-send -a "Shutdown"' )
	exit()
	
os.system( '/usr/bin/reboot '+ sys.argv[ 1 ] )

#!/usr/bin/python
from gpio import *
import urllib
import urllib2
import xml.dom.minidom as minidom

xml = minidom.parse( '/home/osmc/.kodi/userdata/guisettings.xml' )
element = xml.getElementsByTagName( 'webserverport' )
port = element[ 0 ].firstChild.nodeValue

url = 'http://localhost:'+ port +'/jsonrpc'
headerdata = { 'Content-type': 'application/json', 'Accept': 'application/json' }
data = { "jsonrpc":"2.0", "method":"XBMC.GetInfoBooleans", "params":{ "booleans":[ "Player.Playing" ] }, "id":1 }

interval = 60
i = timer
while i > 0:
	time.sleep( interval )
	req = urllib2.Request( url, json.dumps( data ), headers = headerdata )
	response = urllib2.urlopen( req )
	playing = response[ 'result' ][ 'Player.Playing' ]
	if playing == True:
		i = timer
	else:
		i -= 1
		if i == 1:
			os.system( '/usr/bin/xbmc-send -a "Notification( GPIO, Idle Timer OFF in '+ str( interval ) +' seconds, 10000 )"' )
			time.sleep( interval - 10 )
			os.system( '/usr/bin/xbmc-send -a "Notification( GPIO, Idle Timer OFF in 10 seconds, 10000 )"' )
			time.sleep( 10 )
			os.system( '/usr/bin/sudo /home/osmc/gpiooff.py &' )

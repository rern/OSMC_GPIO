#!/usr/bin/python
import sys
import os
import xml.dom.minidom as minidom

if len( sys.argv ) > 1: # usb 'remove'
	os.system( '/usr/bin/xbmc-send -a "Notification(AUDIO OUTPUT,Switched to HDMI)"' )
	exit()

xml = minidom.parse( '/home/osmc/.kodi/userdata/guisettings.xml' )
element = xml.getElementsByTagName('webserverport' )
port = element[ 0 ].firstChild.nodeValue

stdout = os.popen( '/sbin/udevadm info -n /dev/snd/controlC1 -q path' ).read() # read() => 'stdout'\n'result' > 'stdout'\n
path = '/sys'+ stdout.replace( 'controlC1\n', 'id' ) # path of id file
id = os.popen( 'cat '+ path ).read().replace( '\n', '' )

# "ALSA:@:CARD='+ id +',DEV=0" must be exactly, no spaces, as in /home/osmc/.kodi/userdata/guisettings.xml
data = { "jsonrpc": "2.0", "method": "Settings.SetSettingValue", "params": { "setting": "audiooutput.audiodevice", "value": "ALSA:@:CARD='+ id +', DEV=0" }, "id": 1 }

req = urllib2.Request( url, json.dumps( data ), headers = headerdata )
response = urllib2.urlopen( req )

os.system( '/usr/bin/xbmc-send -a "Notification( AUDIO OUTPUT, Switched to USB DAC )"' )

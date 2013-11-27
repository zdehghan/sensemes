require 'rubygems'

$LOAD_PATH << File.dirname(__FILE__)
require 'xbee/serial_port'

# require more xbee modules to be exported here ...

# _zd_ this is just a wip I'm trying to basic stuff out - shall move out of here into external rake commands
sp = XBee::SerialPort.new('/dev/tty.usbserial-AM01P4ZO')
puts sp.pan_id


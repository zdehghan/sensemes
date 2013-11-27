
$LOAD_PATH << File.dirname(File.expand_path(__FILE__))

require 'rake'
require 'rubygems'
require 'lib/xbee.rb'

$serial_port = nil

task :open_device, [:device] do |task, args|
  $serial_port = XBee::SerialPort.new(args[:device])
end

# These tasks if grow can be borken down into smaller rake files
task :get_pan_id, [:device] => [:open_device] do |task, args|
  puts $serial_port.pan_id
end

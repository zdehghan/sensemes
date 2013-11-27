require 'rubygems'
require 'logger'

$log = Logger.new(STDERR)
$log.level = Logger::DEBUG
$log.datetime_format = "%Y-%m-%d %H:%M:%S"

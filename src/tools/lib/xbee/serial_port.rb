require 'rubygems'
require 'serialport'

require 'xbee/config'
require 'xbee/at_cmd'

module XBee

    # Create and open a serial port to an XBee device over USB.
    # It wraps the terminal settings and AT commands for XBee devices.
    class SerialPort

      include XBee::ATCmdRunner
        
      # The underlying serial terminal
      attr_reader :device

      def initialize(dev_path_name)
        begin
          # open serial device and set terminal params suitable for xbee
          @device = ::SerialPort::new(dev_path_name, 9600)
          set_terminal_params

          # test if port opened and responding to command mode
          # commented this out as it doesn't like two consecutive +++ commands
          # init_cmd_mode
          # $log.debug("device #{dev_path_name} initialized successfully")

          # run a block if given on this device & then close the device
          if block_given?
            begin
              yield self
            ensure
              @device.close
            end
          end
        rescue
          # close the device in case of an error
          @device.close
        end

      end

      def set_terminal_params
          # given xbee times out of at cmd mode in 10 second 
          # a few seconds to read its response
          # to a cmd seems reasonable at this point
          # note that 1 second was too short and sometimes I didn't get any response within that time
          @device.read_timeout = 3000

          # Expected values according to http://shop.oreilly.com/product/9780596807740.do
          @device.set_modem_params( {
              :baud        => 9600,
              :data_bits   => 8,
              :stop_bits   => 1,
              :parity      => 0
          }) 
          @device.flow_control = 0
      end
      private :set_terminal_params

    end # SerialPort

end #XBee

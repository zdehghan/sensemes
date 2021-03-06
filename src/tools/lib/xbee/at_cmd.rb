require 'rubygems'

module XBee

    # Implment AT commands to configure and manipulate an xbee over a serial port.
    # Mix it in the target device
    module ATCmdRunner

      class Cmd
        attr_reader :text # Command
        attr_reader :desc # Some human readable description of the command

        def initialize(text, desc)
          @text = text
          @desc = desc
        end
      end

      ATID = Cmd.new("ATID", 'PAN ID')
      MODE = Cmd.new('+++', 'Initialize Command Mode +++')

      # Put device into AT command mode
      def init_cmd_mode
        $log.debug "Running command '#{MODE.text.strip}'"
        self.device.write(MODE.text)
        cmd_run_ok?(MODE)
      end

      # Get PAN ID - all xbees on the same network shall have the same PAN ID
      def pan_id
        run_get_cmd(ATID)
      end

      def run_get_cmd(cmd)
        init_cmd_mode
        $log.debug "Running command '#{cmd.text}'"
        self.device.write("#{cmd.text}\r\n")
        sleep(2)
        value = self.device.readline("\r\n").strip
        if value.nil? or value.empty?
          raise Exception "Failed to run command '#{cmd.text}' no valid value '#{value}' returned" 
        end
        $log.debug "Completed command '#{cmd.text}' successfully - got '#{value}'"
        return value
      end
      private :run_get_cmd

      def cmd_run_ok?(cmd)
        ok = self.device.readline("\r\n").strip
        if !is_ok(ok)
          raise Exception, "#{cmd.desc} failed - heard no OK from the device - expected 'OK' - got '#{ok}'"
        end
        $log.debug "Completed command '#{cmd.text}' successfully - got '#{ok}'!"
      end

      def is_ok(s)
        s == "OK"
      end
      private :is_ok

    end
end

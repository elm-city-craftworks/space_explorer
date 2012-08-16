module SpaceExplorer
  class Radio
    TRANSMISSION_DELAY = 1#60*14 + 6

    def initialize(target)
      @target = target
    end

    def transmit(command)
      start_time = Time.now

      Thread.new do
        sleep 1 while Time.now - start_time < TRANSMISSION_DELAY

        @target.receive_command(command) 
      end
    end
  end
end

module SpaceExplorer
  class Radio
    def initialize(delay)
      @delay = delay
    end

    def establish_connection(target)
      @target = target
    end

    def transmit(command)
      raise "Target not defined" unless defined?(@target)

      start_time = Time.now

      Thread.new do
        sleep 1 while Time.now - start_time < @delay

        @target.receive_command(command) 
      end
    end
  end
end

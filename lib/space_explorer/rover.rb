require "thread"

module SpaceExplorer
  class Rover
    def initialize(world, radio_link)
      @world      = world
      @radio_link = radio_link

      @queue = Queue.new

      Thread.new { loop { process_command(@queue.pop) } }
    end

    def receive_command(command)
      @queue.push(command)
    end

    def process_command(command)
      case command
      when "!PING"
        @radio_link.transmit("PONG")
      when "!NORTH", "!SOUTH", "!EAST", "!WEST"      
        @world.move(command[1..-1])
      when "!SNAPSHOT"
        @world.snapshot { |text| @radio_link.transmit("\n#{text}") }
      else
        # do nothing
      end
    end
  end
end

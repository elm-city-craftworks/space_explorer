require "thread"

module SpaceExplorer
  class Rover
    attr_writer :radio_link

    # TODO: Introduce a position object
    def initialize(world)
      @world = world

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
        @world.snapshot { |data| transmit_encoded_snapshot(data) }
      else
        # do nothing
      end
    end

    private

    def listen_for_commands

    end

    def transmit_encoded_snapshot(data)
      output = data.map { |row| row.join(" ") }.join("\n")

      @radio_link.transmit("\n#{output}")
    end
  end
end

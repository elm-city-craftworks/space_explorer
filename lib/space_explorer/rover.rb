require "thread"

module SpaceExplorer
  class Rover
    attr_writer :radio_link

    # TODO: Introduce a position object
    def initialize(world, row, column)
      @world  = world
      @row    = row
      @column = column

      @queue = Queue.new
    end

    def receive_command(command)
      @queue.push(command)
    end

    def process_command(command)
      case command
      when "!PING"
        @radio_link.transmit("PONG")
      when "!NORTH"
        @row -= 1
      when "!SOUTH"
        @row += 1
      when "!EAST"
        @column += 1
      when "!WEST"
        @column -= 1
      when "!SNAPSHOT"
        @world.snapshot(@row, @column) do |data|
          transmit_encoded_snapshot(data)
        end
      else
        # do nothing
      end
    end

    def listen
      @queue ||= Queue.new

      Thread.new { loop { process_command(@queue.pop) } }
    end

    private

    def transmit_encoded_snapshot(data)
      output = data.map { |row| row.join(" ") }.join("\n")

      @radio_link.transmit("\n#{output}")
    end
  end
end

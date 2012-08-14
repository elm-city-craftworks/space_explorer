require "thread"

module SpaceExplorer

  class World
    def initialize(observer)
      @observer  = observer

      @data      = [[:empty, :empty, :empty, :empty],
                    [:rock,  :empty, :empty, :empty],
                    [:rock,  :empty, :empty, :empty],
                    [:rock,  :rock,  :empty, :empty]]
    end

    def snapshot(reference_point)
      ref_col, ref_row = reference_point

      snapshot = [-1,0,1].product([-1,0,1]).map do |col, row|
        if col == 0 && row == 0
          :rover
        else
          @data[ref_col + col][ref_row + row]
        end
      end

      @observer.snapshot = snapshot.each_slice(3).to_a
    end
  end

  class MissionControl
    def initialize(narrator)
      @narrator = narrator
    end

    attr_writer :radio_link

    def send_command(command)
      @narrator.msg("MISSION CONTROL SENDS: #{command}")
      @radio_link.transmit(command)
    end

    def receive_command(command)
      @narrator.msg("ROVER RESPONDS: #{command}")
    end
  end

  class Rover
    attr_writer :radio_link
    attr_writer :snapshot

    def initialize
      @queue = Queue.new
      @world = World.new(self)

      @column = 2
      @row    = 2
    end

    def receive_command(command)
      @queue.push(command)
    end

    def process_command(command)
      case command
      when "PING"
        @radio_link.transmit("PONG")
      when "NORTH"
        @row -= 1
      when "SOUTH"
        @row += 1
      when "EAST"
        @column += 1
      when "WEST"
        @column -= 1
      when "SNAPSHOT"
        @world.snapshot([@row, @column])

        output = @snapshot.map { |row|
          row.map { |e| { :empty => "-", :rock => "X", :rover => "O" }[e] }.join(" ")
        }.join("\n")

        @radio_link.transmit("\n#{output}")
      else
        @radio_link.transmit("NOT IMPLEMENTED: #{command}")
      end
    end

    def listen
      @queue ||= Queue.new

      Thread.new { loop { process_command(@queue.pop) } }
    end
  end

  class Radio
    TRANSMISSION_DELAY = 1

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

require "cinch"


bot = Cinch::Bot.new

bot.configure do |c|
  c.server = "irc.freenode.org"
  c.channels = ["#seacreature"]
  c.nick     = "roboseacreature"
end

rover            = SpaceExplorer::Rover.new
ground_control   = SpaceExplorer::MissionControl.new(
                    Cinch::Channel.new("#seacreature", bot))

rover.radio_link           = SpaceExplorer::Radio.new(ground_control)
ground_control.radio_link  = SpaceExplorer::Radio.new(rover)

rover.listen

bot.on(:message, /(.*)/) do |m, command|
 ground_control.send_command(command)
end

bot.start


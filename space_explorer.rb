require "thread"

module SpaceExplorer
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

    def initialize
      @queue = Queue.new
    end

    def receive_command(command)
      @queue.push(command)
    end

    def process_command(command)
      case command
      when "PING"
        @radio_link.transmit("PONG")
      when "SNAPSHOT"
        map = ["X - - - -",
               "X - - - -",
               "X X O - -",
               "- X - - X",
               "- - X X -"].join("\n")
        @radio_link.transmit("\n#{map}")
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
    TRANSMISSION_DELAY = 30

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


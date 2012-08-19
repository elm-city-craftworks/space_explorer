module SpaceExplorer
  class MissionControl
    def initialize(narrator, radio_link)
      @narrator   = narrator
      @radio_link = radio_link
    end

    def send_command(command)
      @radio_link.transmit(command)
    end

    def receive_command(command)
      @narrator.msg(command)
    end
  end
end

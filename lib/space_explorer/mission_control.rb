module SpaceExplorer
  class MissionControl
    def initialize(narrator)
      @narrator = narrator
    end

    attr_writer :radio_link

    def send_command(command)
      @radio_link.transmit(command)
    end

    def receive_command(command)
      @narrator.msg(command)
    end
  end
end

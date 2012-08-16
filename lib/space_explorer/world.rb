# coding: UTF-8

module SpaceExplorer
  class World
    DATA_DIR = "#{File.dirname(__FILE__)}/../../data"

    def initialize
      # is this a LOD violation?
      @data = File.read("#{DATA_DIR}/map.txt").lines.map { |e| e.split }
    end

    def snapshot(row, col)
      # is this a LOD violation?
      snapshot = (-2..2).to_a.product((-2..2).to_a).map do |Δrow, Δcol|
        if Δcol == 0 && Δrow == 0
          "@"
        else
          @data[row + Δrow][col + Δcol]
        end
      end

      yield snapshot.each_slice(5).to_a
    end
  end
end

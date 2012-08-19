# coding: UTF-8

module SpaceExplorer
  class World
    DELTAS = (-2..2).to_a.product((-2..2).to_a)

    def initialize(data, row, col)
      @data   = data

      @row    = row
      @col    = col
    end

    def move(direction)
      case direction
      when "NORTH"
        @row -= 1
      when "SOUTH"
        @row += 1
      when "EAST"
        @col += 1
      when "WEST"
        @col -= 1
      else
        raise ArgumentError, "Invalid direction!"
      end
    end

    def snapshot
      snapshot = DELTAS.map do |rowD, colD|
        if colD == 0 && rowD == 0
          "@"
        else
          @data[@row + rowD][@col + colD]
        end
      end

      yield snapshot.each_slice(5).to_a
    end
  end
end

# coding: UTF-8

module SpaceExplorer
  class World
    def initialize(data)
      @data   = data
      @deltas = (-2..2).to_a.product((-2..2).to_a)
    end

    def snapshot(row, col)
      snapshot = @deltas.map do |Δrow, Δcol|
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

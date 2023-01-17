require './zone.rb'

class Board
    attr_accessor :field

    def initialize(rows, cols)
        @rows = rows
        @cols = cols
        @field = Array.new(@rows) { Array.new(@cols) { Zone.new(0) } }
    end

    def legalMove(col)
        @field.each_with_index do |row, rowIndex|
            if @field[rowIndex][col].value == 0
                return true
            end
        end
        return false
    end
end
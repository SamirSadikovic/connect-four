require './board.rb'
require 'fileutils'

class Game
    attr_reader :row, :col, :turnPlayer, :moveHistory

    def initialize(row = 6, col = 7, turnPlayer = 1, moveHistory = Hash['p1' => Array.new(), 'p2' => Array.new()])
        @row = row
        @col = col
        @turnPlayer = turnPlayer
        @moveHistory = moveHistory
        @folderName = ''

        @@board = Board.new(@row, @col)
    end

    def board
        @@board
    end

    def save
        if @folderName == ''
            time = Time.new
            @folderName = "#{time.year}#{time.month}#{time.day}_#{time.hour}#{time.min}#{time.sec}"
        end

        FileUtils.mkdir_p 'games/' + @folderName

        #save board state
        open('games/' + @folderName + '/board.txt', 'w') { |f|
            @@board.field.each_with_index do |row, index|
                row.each do |col|
                    f << col.value
                end
                if index != @@board.field.size - 1
                    f << ","
                end
            end
        }

        #save P1 move history
        open('games/' + @folderName + '/moveHistoryP1.txt', 'w') { |f|
            moveHistory['p1'].each_with_index do |move, index|
                f << move
                if index != moveHistory['p1'].size - 1
                    f << ","
                end
            end
        }

        #save P2 move history
        open('games/' + @folderName + '/moveHistoryP2.txt', 'w') { |f|
            moveHistory['p2'].each_with_index do |move, index|
                f << move
                if index != moveHistory['p2'].size - 1
                    f << ","
                end
            end
        }

        #save turn player
        open('games/' + @folderName + '/turnPlayer.txt', 'w') { |f|
            f << turnPlayer
        }

    end

    def load(folderName)
        @folderName = folderName
        path = "./games/" + @folderName
        r = 0

        #load board state
        line = File.read(path + "/board.txt")
        line.split(',').each do |row|
            c = 0
            row.split('').each do |val|
                @@board.field[r][c].value = val.to_i
                c += 1
            end
            r += 1
        end
        
        #load P1 move history
        line = File.read(path + "/moveHistoryP1.txt")
        line.split(',').each do |move|
           @moveHistory['p1'].push(move.to_i)
        end
        
        #load P2 move history
        line = File.read(path + "/moveHistoryP2.txt")
        line.split(',').each do |move|
            @moveHistory['p2'].push(move.to_i)
        end
        
        #load turn player
        line = File.read(path + "/turnPlayer.txt")
        @turnPlayer = line
    end

    def printUI
        puts $spacer
        
        @@board.field.each do |row|
            row.each do |col|
                print col.valueSymbol
            end
            puts
        end
        
        for colNum in 1...@@board.field[0].length() + 1 do
            if colNum == 1 || colNum / 10 >= 1
                print " "
            else 
                print "  "
            end
            print colNum
        end
        
        puts
        
        puts "Player 1 history: #{@moveHistory['p1']}"
        puts "Player 2 history: #{@moveHistory['p2']}"
    end

    def turnSwitch
        if @turnPlayer == 1
            @turnPlayer = 2
        elsif @turnPlayer == 2
            @turnPlayer = 1
        end
    end

    def endCheck()
        result = false

        for playerChecked  in 1..2 do
            @@board.field.reverse.each_with_index do |row, initialRow|
                row.each_with_index do |zone, initialCol|                    
                    if zone.value != playerChecked
                        next
                    end
            
                    count = 1
            
                    #check rest of row to the right
                    for rowIndex in (initialCol+1)..(row.length-1) do
                        if row[rowIndex].value == playerChecked
                            count += 1
                        else
                            break
                        end
                        if count == 4
                            result = playerChecked
                            return result
                        end
                    end
                    count = 1
            
                    #check rest of column up
                    for columnIndex in (initialRow+1)..(@@board.field.length-1) do
                        if @@board.field.reverse[columnIndex][initialCol].value == playerChecked
                            count += 1
                        else
                            break
                        end
                        if count == 4
                            result = playerChecked
                            return result
                        end
                    end
                    count = 1
            
                    #check primary diagonal
                    columnIndex = initialRow + 1
                    rowIndex = initialCol + 1
            
                    loop do
                        if columnIndex == @@board.field.length || rowIndex == row.length
                            break
                        end
                        
                        if @@board.field.reverse[columnIndex][rowIndex].value == playerChecked
                            count += 1
                            columnIndex += 1
                            rowIndex += 1
                        else
                            break
                        end
            
                        if count == 4
                            result = playerChecked
                            return result
                        end
                    end
                    count = 1
            
                    #check secondary diagonal
                    columnIndex = initialRow + 1
                    rowIndex = initialCol - 1
            
                    loop do
                        if columnIndex == @@board.field.length || rowIndex == 0
                            break
                        end
                        
                        if @@board.field.reverse[columnIndex][rowIndex].value == playerChecked
                            count += 1
                            columnIndex += 1
                            rowIndex -= 1
                        else
                            break
                        end
            
                        if count == 4
                            result = playerChecked
                            return result
                        end
                    end
                    count = 1
                end
            end
        end

        emptySpaces = false
        @@board.field.reverse.each do |row|
            row.each do |zone|
                if zone.value == 0
                    emptySpaces = true
                end
            end
        end

        if !emptySpaces
            result = 0
        end

        return result
    end

    def move(col)
        @@board.field.reverse.each do |row|
            if row[col].value == 0
                row[col].value = @turnPlayer
                break
            end
        end
        @moveHistory['p' + @turnPlayer.to_s].push(col)
        turnSwitch
    end
end
require './game.rb'
$spacer = "----------------------------------------------------------------------"

class Controller

    def initialize
        loop do
            puts $spacer
            puts "1. Start new game"
            puts "2. Load game"
            puts "3. Quit game"
            @userInput = gets.chomp.to_i
        
            if @userInput == 1
                newGame
                break
            elsif @userInput == 2
                loadGame
                break
            elsif @userInput == 3
                goodbye
                break
            else
                puts "Invalid input, try again"
            end
        end
    end

    def gameStart
        loop do
            @game.printUI
            result = @game.endCheck
            if result
                gameEnd(result)
                break
            else
                loop do
                    puts
                    print "Player #{@game.turnPlayer} moves (enter 'S' to save the game, 'Q' to quit without saving): "
                    @userInput = gets.chomp

                    if @userInput.capitalize() == 'S'
                        @game.save
                        puts "Game successfully saved!"
                    elsif @userInput.capitalize() == 'Q'
                        goodbye
                        return
                    elsif @userInput.to_i <= 0 || @userInput.to_i > @game.board.field[0].length || !@game.board.legalMove(@userInput.to_i - 1)
                        puts "Invalid column input, try again."
                    else
                        @game.move(@userInput.to_i - 1)
                        break
                    end
                end
            end
        end
    end

    def gameEnd(result)
        puts $spacer
        if result == 0
            puts "The game is a draw!"
        else
            puts "Player #{result} is the winner!"
            @game.save #saves game to new savefile, have the loaded and previously saved games remember its folderName in the Game class
        end
        puts $spacer

        loop do
            puts "Play again?"
            puts "1. Yes"
            puts "2. No"
            @userInput = gets.chomp.to_i

            if @userInput == 1
                initialize
                break
            elsif @userInput == 2
                goodbye
                break
            else
                puts "Invalid input, try again"
            end
        end
    end

    def loadGame
        savedGames = Dir.entries("./games").drop(2)
        puts $spacer

        if savedGames.length == 0
            puts "No games are currently saved"
            return
        end

        puts "Which game would you like to load? Choose from the list below:"
        
        savedGames.each_with_index do |game, index|
            puts "#{index + 1}. #{savedGames[index]}"
        end
        
        @userInput = gets.chomp
        gameToLoad = savedGames[@userInput.to_i - 1]
        
        @game = Game.new
        @game.load(gameToLoad)
        gameStart
    end

    def newGame
        loop do
            puts $spacer
            puts "Enter the size of the playing field (leave blank for default values)"
            print "Rows (default 6): "
            rows = gets.chomp
            if(rows == '')
                rows = 6
            else
                rows = rows.to_i
            end
            print "Cols (default 7): "
            cols = gets.chomp
            if(cols == '')
                cols = 7
            else
                cols = cols.to_i
            end

            if (rows < 6) || (cols < 7)
                puts "Minimum allowed dimensions are 6x7, try again"
            elsif rows > 20 || cols > 20
                puts "Maximum value for rows and cols is 20, try again"
            elsif (rows - cols).abs > 2
                puts "Rows and columns cannot differ by more than 2, try again"
            else
                @game = Game.new(rows, cols)
                gameStart
                break
            end
        end
    end

    def goodbye
        puts $spacer
        puts "Goodbye!"
    end
end

c = Controller.new

#TODO:
    # Fix saving and loading methods to allow them to overwrite files they were loaded from/saved to
    # Test save game input from controller
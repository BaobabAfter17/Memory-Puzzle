require_relative './board.rb'
require_relative './card.rb'
require_relative './humanplayer.rb'
require_relative './computerplayer.rb'

class Game
    def initialize(n, player)
        @board=Board.new(n)
        @board.populate
        @player = player

    end

    def play
        while  !self.over?
            @board.render

            2.times do |i|
                position = @player.get_input(i,@board.n)
                make_guess(position)
            end

            sleep(1)
            system("clear")
            @previous_guess=@guessed_pos=nil
        end
        @board.render
        puts "#{@player.name}, you WON!"
    end

    def over?
        if @board.won?
            (0...@board.n).each do |i|
                (0...@board.n).each do |j|
                    @board.grid[i][j].reveal
                end
            end
        end
    end

    def make_guess(pos)
        if @previous_guess==nil
            @guess_pos=pos
            current_value=@board.reveal(@guess_pos)
            @player.receive_revealed_card(@guess_pos, current_value)
            @board.render         
            @previous_guess=@guess_pos
        else 
            @guess_pos=pos
            @board.reveal(@guess_pos)
            @board.render
            current_value = @board.reveal(@guess_pos)
            previous_value = @board.reveal(@previous_guess)
            @player.receive_revealed_card(@guess_pos, current_value)

            if  current_value != previous_value
                     @board.grid[@guess_pos[0]][@guess_pos[1]].hide
                     @board.grid[@previous_guess[0]][@previous_guess[1]].hide
            else
                @player.receive_match(@guess_pos, @previous_guess)
            end
        end
    end
end


player = HumanPlayer.new('user_name')
# player = ComputerPlayer.new('Bot')
g = Game.new(6, player)
g.play
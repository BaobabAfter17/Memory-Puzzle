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

            2.times do |i|#first guess
                # puts "Select first position in this form: 2 3"
                # position = gets.chomp.split.map(&:to_i)
                position = @player.get_input(i,@board.n)
                make_guess(position)
            end

            sleep(1)
            system("clear")
            # reset @previous_guess, @guessed_pos etc.
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
        # judge wether this is first guess by checking @guessed_pos and @previous_guess
        if @previous_guess==nil
        #if first guess
            @guess_pos=pos
            # store pos in @guess_pos
            current_value=@board.reveal(@guess_pos)
            # reveal the card at @guessed_pos
            @player.receive_revealed_card(@guess_pos, current_value)
            @board.render         
            # render board
            @previous_guess=@guess_pos
            # update @previous_pos using pos
        else 
        #if second guess
            @guess_pos=pos
            # update @guess_pos
            @board.reveal(@guess_pos)
            # reveal both cards at current and previous position
            @board.render
            # render board
            current_value = @board.reveal(@guess_pos)
            previous_value = @board.reveal(@previous_guess)
            @player.receive_revealed_card(@guess_pos, current_value)
            # compare result of both reveals
                # if same
                    # reveal both cards forever / turn both card face up
            if  current_value != previous_value
                # else not same
                     @board.grid[@guess_pos[0]][@guess_pos[1]].hide
                     @board.grid[@previous_guess[0]][@previous_guess[1]].hide
                    # turn both cards into face down
            else
                @player.receive_match(@guess_pos, @previous_guess)
            end
        end
    end
end


# player = HumanPlayer.new('Arthur')
player = ComputerPlayer.new('Liz')
g = Game.new(6, player)
g.play
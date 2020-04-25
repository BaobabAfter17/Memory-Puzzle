require_relative './card.rb'
require 'byebug'
class Board
    attr_reader :grid, :n

    def initialize(n)
        @grid = Array.new(n) {Array.new(n, " ")}
        @n = n
    end

    def populate
        length = @n * @n / 2
        arr = ('A'..'Z').to_a[0...length] * 2
        new_arr = arr.shuffle
        cards_arr = new_arr.map {|ele| Card.new(ele)}      

        (0...@n).each do |i|
            (0...@n).each do |j|
                @grid[i][j] = cards_arr.pop
            end
        end

    end

    def render
        (0...@n).each do |i|
            print " "+i.to_s
        end
        puts
        @grid.each_with_index do |row,j|
            print j.to_s
            row.each do |ele|
                if ele.face_up
                    print ele.face_value + " " 
                else
                    print "  "
                end
            end
            puts
        end
    end

    def won?
        @grid.flatten.count{|ele| !ele.face_up}<=2
    end

    def reveal(position)
        row, col = position
        @grid[row][col].reveal
        return  @grid[row][col].face_value
    end

end

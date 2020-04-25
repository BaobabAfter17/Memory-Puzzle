class HumanPlayer
    attr_reader :name
    def initialize(name)
        @name = name
    end

    def get_input(i, n)
        puts "Select first position in this form: 2 3"
        gets.chomp.split.map(&:to_i)
    end
end
class ComputerPlayer
    attr_reader :name
    def initialize(name = 'Bot')
        @name = name
        @known_cards = Hash.new{|k,v| v=[]}
        @matched_cards = []
        @first_guess = []
    end

    def get_input(i,n)

        if i == 0
            unrevealed_pairs=@known_cards.select {|k,v| v.length==2}
                            .select{|k,v|!@matched_cards.include?v[0]}
            if !unrevealed_pairs.empty?
                @first_guess = unrevealed_pairs.values.sample[0]
                return @first_guess
            else
                self.random_pos(n)
            end
        else        
            first_guess_hash=@known_cards.select{|k,v| v.include?(@first_guess)} 
            first_guess_pairs_or_single = first_guess_hash.values[0] 
            if first_guess_pairs_or_single.length == 2 
                first_guess_partner = []
                first_guess_pairs_or_single.each do |ele|
                    first_guess_partner = ele if ele != @first_guess 
                end
                return first_guess_partner
            else
                self.random_pos(n)
            end
        end
    end

    def receive_revealed_card(position, value)
        if !@known_cards[value].include?(position)
            @known_cards[value]<<=position
        end
    end

    def receive_match(position_1, position_2)
        @matched_cards<<position_1
        @matched_cards<<position_2
    end

    def random_pos(n)
        pool = []
        (0...n).each do |i|
            (0...n).each do |j|
                pos = [i, j]
                know_pairs_or_single = @known_cards.values

                included = know_pairs_or_single.any? do |ele|
                    ele.include?(pos)
                end

                pool << pos if !included
            end
        end         
        @first_guess = pool.sample
        return @first_guess
    end
end


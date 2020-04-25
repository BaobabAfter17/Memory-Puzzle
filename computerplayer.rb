require 'byebug'
class ComputerPlayer
    attr_reader :name
    def initialize(name = 'Bot')
        @name = name
        @known_cards = Hash.new{|k,v| v=[]}
        # 'A'=>[pos, pos] 'B'=> [pos]
        @matched_cards = []
        @first_guess = []
    end

    def get_input(i,n)
        # if first guess

        if i == 0
        # if knows 2 matching cards
            unrevealed_pairs=@known_cards.select {|k,v| v.length==2}
                            .select{|k,v|!@matched_cards.include?v[0]}
            if !unrevealed_pairs.empty?
                @first_guess = unrevealed_pairs.values.sample[0]
                return @first_guess
                # choose one of them

            # else
            else
                self.random_pos(n)
                # choose randomly = B
            end
        else
        # else if second guess
            # [A, A] [A, A, B, C, D] first_guess => D?
        
            first_guess_hash=@known_cards.select{|k,v| v.include?(@first_guess)} # {'A'=>[pos, pos]} or {'A'=>[pos]}
            first_guess_pairs_or_single = first_guess_hash.values[0] # [pos, pos] or [pos]
            # if first guess matches of the known card
            if first_guess_pairs_or_single.length == 2 # if [pos, pos]
                # choose that known card
                first_guess_partner = []
                first_guess_pairs_or_single.each do |ele|
                    first_guess_partner = ele if ele != @first_guess 
                end
                # first_guess_partner = first_guess_pairs_or_single[0] # must be first one because first_guess last in
                return first_guess_partner
            else
                # choose randomly
                self.random_pos(n)
            end
        end
    end

    def receive_revealed_card(position, value)
        #debugger 
        if !@known_cards[value].include?(position)
            @known_cards[value]<<=position
        end
    end

    def receive_match(position_1, position_2)
        @matched_cards<<position_1
        @matched_cards<<position_2
    end

    def random_pos(n)
        # while true
        #     row=rand(0...n)
        #     col=rand(0...n)
        #     pos=[row,col]
        #     know_pairs_or_single = @known_cards.values
        #     included = know_pairs_or_single.any? do |ele|
        #         ele.include?(pos)
        #     end
        #     @first_guess = pos
        #     return pos if !included
        # end
        pool = []
        (0...n).each do |i|
            (0...n).each do |j|
                pos = [i, j]
                know_pairs_or_single = @known_cards.values

                # counter = 0
                # know_pairs_or_single.each do |ele|
                #     counter += ele.length
                # end
                # p counter

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


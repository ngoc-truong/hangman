
class Game
    attr_accessor :word, :past_guesses, :num_guesses, :max_guesses, :player

    def initialize(max_guesses, dictionary)
        @words = dictionary
        @word = ""
        @past_guesses = []
        @wrong_guesses = 0
        @max_guesses = max_guesses
        @player = Player.new
    end

    ### Methods for preprocessing and getting the target word
    def words_with_min_max_characters(lines_from_file, min, max)
        accepted_words = []
        lines_from_file.each do |line| 
            line = line.slice(0...line.index("\r"))
            if line.size >= min && line.size <= max
                accepted_words << line
            end
        end
        accepted_words
    end

    def get_random_word(array)
        array.sample
    end

    def set_word
        lines = File.readlines(@words)
        words = words_with_min_max_characters(lines, 5, 12)
        @word = get_random_word(words)
    end

    ### Game mechanics
    def print_result
        result = ""

        self.word.downcase.each_char do |char|
            @past_guesses.uniq.each do |guess|
                if char == guess 
                    result += " #{char} "
                end
            end

            if !@past_guesses.include?(char)
                result += " _ "
            end
        end

        result[1].upcase + result[2..-1]
    end

    # same as "win?"
    def has_underscores?
        print_result.chars.include?("_")
    end

    def start
        self.set_word

        while self.has_underscores?
            if @past_guesses.empty? 
                puts self.print_result
            end

            guess = @player.guess
            @past_guesses << guess
            puts self.print_result
            puts ""
            puts "Your past guesses are: #{@past_guesses.join(', ')}"

            if !self.word.chars.include?(guess)
                @wrong_guesses += 1
            end
        
            puts ""
            puts "You have #{@wrong_guesses} wrong guesses. You have #{@max_guesses - @wrong_guesses} wrong guesses left." 
            puts ""
            if @wrong_guesses >= @max_guesses 
                puts ""
                puts "Sorry, you lose!"
                puts "The word was #{self.word}."
                puts ""
                return
            end
        end

        puts ""
        puts "Congratulations, you won!"
        puts ""
    end
end


class Player
    def guess
        puts ""
        puts "Please provide me a character, beep beep di boop!"
        char = gets.chomp
        puts ""

        while char.size > 1
            puts ""
            puts "I am sorry, but you cannot choose that many characters, dum dum!"
            puts "Please choose another character!"
            char = gets.chomp
            puts ""
        end
        
        return char
    end
end


# Testing
game = Game.new(10, "5desk.txt")
game.start
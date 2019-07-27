require 'json'


class Game
    attr_accessor :word, :past_guesses, :wrong_guesses, :max_guesses, :player

    def initialize(max_guesses, dictionary, word = "", past_guesses = [], wrong_guesses = 0, player = Player.new )
        @max_guesses = max_guesses
        @words = dictionary
        @word = word
        @past_guesses = past_guesses
        @wrong_guesses = wrong_guesses
        @player = player
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
        # Only if there is no word from a saved game
        if self.word == ""  
            self.set_word
        end

        while self.has_underscores?
            if @past_guesses.empty? 
                puts self.print_result
            end

            guess = @player.guess

            # Save the game
            while guess == "save"
                print "Please provide a filename: "
                filename = gets.chomp.downcase

                self.save_as(filename)
                guess = @player.guess
            end

            # Chosen char already in past_guesses
            while @past_guesses.include?(guess)
                puts ""
                puts ""
                puts ""
                puts "You already took this character. Please choose another one!!!".upcase
                puts ""
                puts ""
                puts ""
                guess = @player.guess
            end

            @past_guesses << guess

            puts self.print_result
            puts ""
            puts "Your past guesses are: #{@past_guesses.join(', ')}"

            # Update wrong_guesses
            if !self.word.chars.include?(guess)
                @wrong_guesses += 1
            end
        
            puts "You have #{@wrong_guesses} wrong guesses. You have #{@max_guesses - @wrong_guesses} wrong guesses left." 
            puts ""
            if @wrong_guesses >= @max_guesses 
                puts "----------------"
                puts "Sorry, you lose!"
                puts "----------------"
                puts "The word was #{self.word}."
                puts ""
                return
            end
        end

        puts "-------------------------"
        puts "Congratulations, you won!"
        puts "-------------------------"
    end

    ### Saving and JSON serialization
    def save_as(filename)
        file = File.open("./save_games/#{filename}.txt", "w")
        file.puts self.to_json
        file.close
    end

    def load(file)
        Game.from_json(file)
    end

    def to_json
        JSON.dump( {
            :max_guesses => @max_guesses,
            :dictionary => @words,
            :word => @word, 
            :past_guesses => @past_guesses,
            :wrong_guesses => @wrong_guesses
        })
    end

    def self.from_json(file)
        data = JSON.load(File.read(file))
        self.new(   data["max_guesses"], 
                    data["dictionary"], 
                    data["word"],
                    data["past_guesses"], 
                    data["wrong_guesses"], 
                    Player.new )    # Json only saves Player object as a string, so we create a new one
    end
end


class Player
    def guess
        puts "---------------------------------------------------------------------------"
        puts "You can save your game by typing 'save'."
        puts "If you want to continue, provide me a character, please, beep beep di boop!"
        puts "---------------------------------------------------------------------------"

        char = gets.chomp
        puts ""

        if char.downcase == "save"
            return char
        end

        while char.size > 1
            puts "---------------------------------------------------------------"
            puts "I am sorry, but you cannot choose that many characters, dumdum!"
            puts "Please choose another character!"
            puts "---------------------------------------------------------------"
            char = gets.chomp
        end
        
        return char
    end
end


# Testing
puts "----------------------------------------"
puts "Do you want to load your old game (y/n)?"
puts "----------------------------------------"

answer = gets.chomp.downcase

if answer == "y" || answer == "load"
    puts Dir.entries("./save_games/")
    puts "------------------------------"
    puts "Which one do you want to load?"
    puts "------------------------------"

    filename = gets.chomp
    game = Game.from_json("./save_games/#{filename}")
else 
    game = Game.new(10, "5desk.txt")
end

game.start
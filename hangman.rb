require "yaml"

class Game

  def initialize (game)
  @word = choose_random_word("5desk.txt")
  @board = Board.new(@word.length)
  @letter_guessed = ""
  @letters_array = @word.chars
  @letters_remaining_array = @word.chars
  @letters_guessed_array = []
  @number_of_guesses_counter = 8
  
  end

  def play(game)
    loop do
      @board.render
      puts "Letters guessed: #{@letters_guessed_array.join(",")}"
      puts "Number of guesses left: #{@number_of_guesses_counter}"
      ask_to_save_game(game)
      ask_player_for_letter
      if valid_letter?
        if letter_already_guessed? == false
          if letter_in_word?
            @board.place_letter(@letters_array, @letter_guessed, @letters_remaining_array)
          end
        end
      end
      if @number_of_guesses_counter <= 0
        @board.render
        puts "Letters guessed: #{@letters_guessed_array.join(",")}"
        puts "Number of guesses left: #{@number_of_guesses_counter}"
        puts
        puts "You have no more guesses left and have lost the game."
        break
      elsif game_over?
        @board.render
        puts "Letters guessed: #{@letters_guessed_array.join(",")}"
        puts "Number of guesses left: #{@number_of_guesses_counter}"
        puts
        puts "You guessed every letter in the mystery word and have won the game!"
        break
      end
    end
  end

  def create_words_array (txt)
    words = File.read "#{txt}"
    words.split("\r\n")
  end

  def create_filtered_words_array (words_array)
    words_array.select {|word| (5..12) === word.length}
  end

  def choose_random_word (txt)
    words_array = create_words_array(txt)
    filtered_words_array = create_filtered_words_array(words_array)
    filtered_words_array.sample
  end

  def ask_player_for_letter
    puts "Guess a letter from the mystery word..."
    @letter_guessed = gets.chomp

  end

  def valid_letter?
    if @letter_guessed.length == 1
      if (("a".."z") === @letter_guessed) || (("A".."Z") === @letter_guessed)
        return true
      else
        puts "#{@letter_guessed} is not a letter..."
        return false
      end

    else
      puts "Please input only one character for the letter..."
      return false
    end
  end

  def letter_already_guessed?
    @letters_guessed_array.each do |letter|
      if (letter == @letter_guessed.upcase) || (letter == @letter_guessed.downcase)
        puts "You've already guessed that letter..."
        return true
        
      end
      
    end
    @letters_guessed_array.push(@letter_guessed)
    return false
  end


  def letter_in_word?
    @letters_array.each do |character|
      if (character == @letter_guessed.upcase) || (character == @letter_guessed.downcase)
        puts "#{@letter_guessed} is in the mystery word!"
        return true
      end
    end
    @number_of_guesses_counter -= 1
    puts "#{@letter_guessed} is not part of the mystery word."
    return false
  end

  def game_over? 

    if @letters_remaining_array.empty?
      return true
    else
      return false
    end
  end

  def ask_to_save_game(game)
    puts "Type 'save' to save the current game."
    answer = gets.chomp
    if (answer == "save") || (answer == "Save") || (answer == "SAVE")
      save_game(game)

    else 
      puts "Continuing with the game..."
    end
  end

  def saved_game
      YAML.load_file("savedgame.txt")
  end
  
  def save_game(game)
    puts "Game saved."
    File.open("savedgame.txt","w") do |file|
      file.write game.to_yaml
    end
  end

  def ask_to_load_game(game)
    puts "Type 'load' to load previous game..."
    answer = gets.chomp
    if (answer == "load") || (answer == "LOAD") || (answer == "Load")
      game = game.saved_game
      game.play(game)
    else
      puts "Starting new game..."
      game.play(game)
    end
  end

end

class Board

  def initialize (word_length)
    @board = Array.new(word_length) {Array.new(1)}
  end

  def render

    @board.each do |row|
      row.each do |cell|
        cell.nil? ? print("_ ") : print(cell.to_s)
      end

    end

    puts

  end

  def place_letter (letters_array, letter_guessed, letters_remaining_array)
    place_letter_hash = {}
    letters_array.each_with_index do |letter, index|
      if (letter == letter_guessed.upcase) || (letter == letter_guessed.downcase)
        place_letter_hash [index] = letter
        letters_remaining_array.delete(letter)

      end
    end

    place_letter_hash.each do |key, value|
      @board[key][0] = "#{value} "
    end

  end

end

game = Game.new(game)

game.ask_to_load_game(game)
























































































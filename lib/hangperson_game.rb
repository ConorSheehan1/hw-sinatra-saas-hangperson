class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def word_with_guesses
    to_return = ""
    self.word.split("").each do |char|
      if guesses.include? char
        to_return += char
      else
        to_return += "-"
      end
    end
    return to_return
  end

  def guess(letter)
    raise ArgumentError.new("Guess cannot be empty") if letter.nil? || letter.empty? || letter =~ /[^a-zA-Z]/
    # include every unique guess in guesses
    # only include wrong ones in wrong_guesses
    letter = letter.downcase
    if !self.word.include? letter
      if !self.wrong_guesses.include? letter
        self.wrong_guesses += letter 
      else
        return false
      end
    else
      # only add letter to guesses if it's not in there already
      if !self.guesses.include? letter
        self.guesses += letter 
      else
        return false
      end
    end
  end

  def check_win_or_lose
    if self.wrong_guesses.length >= 7
      return :lose
    elsif !self.word_with_guesses.include? "-"
      return :win
    else
      return :play
    end
  end
end

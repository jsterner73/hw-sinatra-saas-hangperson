class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses        = ''
    @wrong_guesses  = ''
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def guess g
    raise ArgumentError if g.nil? || g.empty? || g =~ /[^a-zA-Z]/

    g.downcase!
    r = false
    if @word.include?(g) && !@guesses.include?(g)
      @guesses.concat(g)
      r = true
    elsif !@word.include?(g) && !@wrong_guesses.include?(g)
      @wrong_guesses.concat(g)
      r = true
    end
    r
  end

  def word_with_guesses
    mask = '-' * @word.length
    @word.length.times do |i|
      l = @word[i]
      mask[i] = l if @guesses.include?(l)
    end
    mask
  end

  def check_win_or_lose
    if @wrong_guesses.length >= 7
      :lose
    elsif word_with_guesses.count('-') == 0
      :win
    else
      :play
    end
  end

end

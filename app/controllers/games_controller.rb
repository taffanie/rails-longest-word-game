require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    # display new random grid and form
    @letters = (0...10).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    # form will be submitted (with POST) to the score action

    @attempt = params[:word]
    @letters = params[:letters]
    @exists = word_exists?(@attempt)

    if @attempt.upcase.split("").all? { |i| @letters.include?(i) } && word_exists?(@attempt)
      @response = "Congratulations! #{@attempt.upcase} is a valid English word!"
    elsif !word_exists?(@attempt) && @attempt.upcase.split("").all? { |i| @letters.include?(i) }
      @response = "Sorry but #{@attempt.upcase} does not seem to be an English word!"
    else
      @response = "Sorry but #{@attempt.upcase} can't be built out of #{@letters}!"
    end
  end

  private

  def word_exists?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    word["found"]
  end
end

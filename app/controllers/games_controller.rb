require 'json'
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample }
  end

  def score
    @result = full_answer_validation(params[:answer], params[:letters])
  end

  private

  def full_answer_validation(answer, letters)
    if valid_grid?(answer, letters) && valid_english?(answer)
      "Congratulations!!! #{answer.upcase} is a valid English word..."
    elsif valid_grid?(answer, letters)
      "Sorry #{answer.upcase} does not seem to be a valid English word..."
    elsif valid_english?(answer)
      "The word can't be built out of the grid"
    else
      'WRONG'
    end
  end

  def valid_grid?(answer, letters)
    answer = answer.split('')
    answer.each { |char| return false unless letters.include? char }
  end

  def valid_english?(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    opened_url = URI.parse(url).open
    dict_result = JSON.parse(opened_url.read)
    dict_result['found']
  end
end

# "<strong>Congratulations!!!</strong> #{@answer.upcase} is a valid English word..."
# "Sorry <strong>#{@answer.upcase}</strong> does not seem to be a valid English word..."

# The word can’t be built out of the original grid
# The word is valid according to the grid, but is not a valid English word
# The word is valid according to the grid and is an English word

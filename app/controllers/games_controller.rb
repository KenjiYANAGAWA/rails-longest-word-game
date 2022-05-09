require 'json'
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample }
  end

  def score
    @result = full_answer_validation(params[:answer], params[:letters])
    @score = params[:answer].length if @result[1]
  end

  private

  def full_answer_validation(answer, letters)
    grid = valid_grid?(answer, letters)
    english = valid_english?(answer)

    if grid && english
      ["Congratulations!!! #{answer.upcase} is a valid English word...", true]
    elsif grid
      ["Sorry #{answer.upcase} does not seem to be a valid English word...", false]
    elsif english
      ["The word can't be built out of the grid", false]
    else
      ['WRONG', false]
    end
  end

  def valid_grid?(answer, letters)
    answer = answer.split('')
    letters.split(' ')
    answer.each do |char|
      return false unless letters.include? char

      letters.slice!(letters.index(char))
    end
    true
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

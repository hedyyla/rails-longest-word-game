require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    alphabets = ('A'..'Z').to_a

    10.times do
      @letters << alphabets[rand(26) - 1]
    end

    @letters
  end

  def score
    @letters = params[:letters].split
    @attempt = params[:attempt]
    @message = message(@attempt, @letters)
    # @score = points(@attempt, @letters, start_time, end_time)
    @message
  end

  def check_letters(check_attempt, grid)
    check_attempt = check_attempt.upcase
    # run through attempt array - for each, see whether it exists in grid
    # if it does, delete the letter from grid, return true
    # if doesn't return false
    is_found = true
    attempt_array = check_attempt.chars
    attempt_array.each do |letter|
      # if check_grid(attempt_array, grid) == true
      #   index = grid.index(letter)
      #   grid.delete_at(index)
      if grid.include?(letter)
        index = grid.index(letter)
        grid.delete_at(index)
      else
        is_found = false
      end
    end
    is_found
  end

  def message(attempt, grid)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    results_serialized = URI.open(url).read
    results = JSON.parse(results_serialized)
    if results["found"]
      return "Well done!"
    elsif !check_letters(attempt, grid)
      return "not in the grid"
    else
      return "not an english word"
    end
  end

  def points(attempt, grid, start_time, end_time)
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    results_serialized = URI.open(url).read
    results = JSON.parse(results_serialized)
    @time = end_time - start_time
    return 0 if results["found"] != true
    return 0 if check_letters(attempt, grid) == false

    return (results["length"].to_i * 2) / time.to_i
  end
end

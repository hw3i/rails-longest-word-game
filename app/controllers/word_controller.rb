class WordController < ApplicationController

  def game
    @grid = generate_grid(9)
    @start_time = DateTime.now
  end

  def score
    @start_time = DateTime.parse(params["time"])
    @end_time = DateTime.now
    @time_taken = ((@end_time - @start_time) * (24 * 60 * 60)).to_f.round(1)
    @guess = params[:query]
    @grid = params[:grid]
    @score = score_and_message(@guess, @grid, @time_taken)
    @average = total_score(@score) / count
    p session.to_hash
  end

  private

  def count
    if session[:count].nil?
      session[:count] = 1
    else
      session[:count] += 1
    end
  end

  def total_score(score)
    if session[:total].nil?
      session[:total] = score
    else
      session[:total] += score
    end
  end

  def generate_grid(grid_size)
    @letters = []
    grid_size.times do
      @letters << ("A".."Z").to_a.sample
    end
    return @letters
  end

  def included?(guess, grid)
    new_guess = guess.split()
    new_guess.all? { |letter| new_guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)
    attempt.length * (1 - time_taken / 60)
  end

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      @score = (compute_score(attempt, time)).to_f.round(1)
    else
      @score = 0
    end
  end
end

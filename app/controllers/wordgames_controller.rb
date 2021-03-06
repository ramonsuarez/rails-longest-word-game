class WordgamesController < ApplicationController
  def game
    @grid = generate_grid(9)
  end

  def score
    session[:end_time] = Time.now.to_i
    session[:attempt] = params[:attempt]
    # @start_time = params[:start_time].to_i
    # @grid = params[:grid]
    # @attempt = params[:attempt]
    @result = run_game(session[:attempt], session[:grid], session[:start_time], session[:end_time])
  end

# Add methods from exercise answer below
private

require 'open-uri'
require 'json'

def generate_grid(grid_size)
  Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
end


def included?(guess, grid)
  guess = guess.chars
  guess.all? { |letter| guess.count(letter) <= grid.count(letter) }
end

def compute_score(attempt, time_taken)
  (time_taken > 60.0) ? 0 : attempt.size * (1.0 - time_taken / 60.0)
end

def run_game(attempt, grid, start_time, end_time)
  result = { time: end_time - start_time }
  result[:translation] = get_translation(attempt)
  result[:score], result[:message] = score_and_message(
    attempt, result[:translation], grid, result[:time])
  result
end

def score_and_message(attempt, translation, grid, time)
  if included?(attempt.upcase, grid)
    if translation
      score = compute_score(attempt, time)
      [score, "well done"]
    else
      [0, "not an english word"]
    end
  else
    [0, "not in the grid"]
  end
end

def get_translation(word)
  #api_key = "YOUR_SYSTRAN_API_KEY"
  #begin
    #response = open("https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{api_key}&input=#{word}")
    response = open("http://api.wordreference.com/0.8/80143/json/enfr/#{word.downcase}")
    json = JSON.parse(response.read.to_s)
    json['term0']['PrincipalTranslations']['0']['FirstTranslation']['term'] unless json["Error"]
  #   if json['out'] && json['out'][0] && json['out'][0]['output'] && json['out'][0]['output'] != word
  #     return json['out'][0]['output']
  #   end
  # rescue
  #   if File.read('/usr/share/dict/words').upcase.split("\n").include? word.upcase
  #     return word
  #   else
  #     return nil
  #   end
  # end
end

end


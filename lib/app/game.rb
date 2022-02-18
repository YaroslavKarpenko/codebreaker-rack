# frozen_string_literal: true

require 'pry'
class Game
  include SessionData
  attr_accessor :game_session

  def initialize(request)
    @request = request
    @game_session = load_game_session(@request.session[:id]) || Codebreaker::Game.new
  end

  def add_hint
    @request.session[:hints] << @game_session.use_hint
    save_game_data
  end

  def start_game_session
    set_game_configuration
    save_game_data
  end

  def set_game_session_configuration
    matrix = set_matrix
    @request.session[:matrix] = matrix
    save_game_data
  end

  def save_game_data
    game_session_id = save_game_session(game_session)
    @request.session[:id] = game_session_id
  end

  def reset_game_session_data
    @request.session[:matrix] = []
    @request.session[:hints] = []
  end

  def matrix
    @request.session[:matrix]
  end

  def hints
    @request.session[:hints]
  end

  def game_exists?
    @request.session.include? 'id'
  end

  private

  def set_matrix
    @game_session.display_matrix(@request.params['number'].chars.map(&:to_i))
  end

  def set_game_configuration
    @game_session.difficulty = @request.params['level'].downcase.to_sym
    @game_session.user.name = @request.params['player_name']
    @game_session.assign_difficulty
  end
end

# frozen_string_literal: true

module LevelHepler
  def level_configuration(game_session, param)
    Codebreaker::Game::DIFFICULTIES[game_session.difficulty][param]
  end

  def level(game_session)
    game_session.difficulty.to_s.capitalize
  end
end

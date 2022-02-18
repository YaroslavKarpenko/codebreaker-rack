# frozen_string_literal: true

class GameController < BasicController
  def initialize(request)
    super
    @current_session = Game.new(@request)
  end

  def win
    return redirect_to_menu unless win_game?

    save_results
    @response = rack_response(WIN)
    clear_session
    @response
  end

  def lose
    return redirect_to_menu unless lose_game?

    @response = rack_response(LOSE)
    clear_session
    @response
  end

  def game
    redirect_to_menu_by_game_exists_check

    @response || rack_response(GAME)
  end

  def hint
    redirect_to_menu_by_game_exists_check

    @current_session.add_hint if hint_available?

    @response || redirect_to_game
  end

  def guess
    redirect_to_menu_by_game_exists_check || redirect_by_checking_number

    unless @response
      @current_session.set_game_session_configuration
      win_redirection || lose_redirection
    end
    @response || redirect_to_game
  end

  def index
    @response = redirect_to_game if @current_session.game_exists?
    @response = rack_response('menu') if !@response && @request.params.empty?

    unless @response
      @current_session.start_game_session
      @current_session.reset_game_session_data
    end
    @response || redirect_to_game
  end

  private

  def win_game?
    @current_session.game_exists? || win_condition?
  end

  def lose_game?
    @current_session.game_exists? && lose_condition?
  end

  def win_condition?
    @current_session.game_session.win?(@request.params['number'].chars.map(&:to_i))
  end

  def lose_condition?
    @current_session.game_session.lose?
  end

  def clear_session
    @request.session.clear
  end

  def save_results
    @current_session.game_session.save_game(@current_session.game_session)
  end

  def win_redirection
    return unless win_condition?

    @current_session.save_game_data
    @response = redirect_to_win
  end

  def lose_redirection
    return unless lose_condition?

    @response = redirect_to_lose
  end

  def hint_available?
    @response.nil? && @current_session.game_session.check_for_hints?
  end

  def redirect_to_menu_by_game_exists_check
    @response = redirect_to_menu unless @current_session.game_exists?
  end

  def redirect_by_checking_number
    @response = redirect_to_game if @request.params['number'].nil?
  end

  def redirect_to_menu
    redirect(ROOT)
  end

  def redirect_to_game
    redirect(GAME)
  end

  def redirect_to_lose
    redirect(LOSE)
  end

  def redirect_to_win
    redirect(WIN)
  end
end

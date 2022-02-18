# frozen_string_literal: true

class Application
  include PathConstants
  include WebHelper

  ROUTES = { ROOT => { class: GameController, method: :index },
             GUESS => { class: GameController, method: :guess },
             GAME => { class: GameController, method: :game },
             HINT => { class: GameController, method: :hint },
             WIN => { class: GameController, method: :win },
             LOSE => { class: GameController, method: :lose },
             RULES => { class: RulesController, method: :rules },
             STATISTICS => { class: StatisticsController, method: :statistics } }.freeze

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def self.call(env)
    new(env).response.finish
  end

  def response
    return command if path_exists?

    redirect(ROOT)
  end

  def command
    ROUTES[path][:class].new(@request).public_send(ROUTES[path][:method])
  end

  def path_exists?
    ROUTES.include?(path)
  end

  def path
    @request.path
  end

  private :initialize, :command, :path_exists?, :path
end

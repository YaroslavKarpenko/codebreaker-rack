# frozen_string_literal: true

class BasicController
  include LevelHepler
  include PathConstants
  include WebHelper

  def initialize(request)
    @request = request
  end
end

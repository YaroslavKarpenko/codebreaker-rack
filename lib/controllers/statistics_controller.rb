# frozen_string_literal: true

class StatisticsController < BasicController
  def statistics
    rack_response('statistics')
  end
end

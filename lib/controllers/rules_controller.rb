# frozen_string_literal: true

class RulesController < BasicController
  def rules
    rack_response('rules')
  end
end

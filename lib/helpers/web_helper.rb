# frozen_string_literal: true

module WebHelper
  BASE_FILE_PATH = '../../views/'
  BASE_FILE_NAME = 'base'
  BASE_FILE_FORMAT = '.html.haml'

  def redirect(file_name)
    Rack::Response.new { |response| response.redirect(file_name) }
  end

  def rack_response(file_name)
    Rack::Response.new(rack_render(BASE_FILE_NAME) { rack_render(file_name) })
  end

  def rack_render(file_name)
    Haml::Engine.new(File.read(path(file_name))).render(binding)
  end

  private

  def path(file_name)
    File.expand_path("#{BASE_FILE_PATH}#{file_name}#{BASE_FILE_FORMAT}", __FILE__)
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../', __FILE__)
require 'standards'
require 'admin_app'

middleware = Class.new {
  def initialize(app)
    @app = app
  end

  def call(env)
    timeline, structure = Standards::Persistence.load 'standards.json'
    env['standards'] = {
      'timeline'  => timeline,
      'structure' => structure,
    }
    @app.call(env)
  end
}

use middleware
run AdminApp

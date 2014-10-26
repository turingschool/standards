require 'sinatra'

class AdminApp < Sinatra::Base
  get '/' do
    # taken from one of the specs
    @structure = env['standards']['structure']
    h1 = @structure.add_hierarchy name: 'h1', parent_id: 1
    h2 = @structure.add_hierarchy name: 'h2', parent_id: h1.id
    h3 = @structure.add_hierarchy name: 'h3', parent_id: h2.id
    h4 = @structure.add_hierarchy name: 'h4', parent_id: h1.id
    erb :structure
  end
end

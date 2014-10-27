require 'sinatra'

class AdminApp < Sinatra::Base
  get '/' do
    erb :structure
  end

  get '/structure.json' do
    content_type :json
    # taken from one of the specs
    @structure = env['standards']['structure']
    h1 = @structure.add_hierarchy name: 'h1', parent_id: 1
    h2 = @structure.add_hierarchy name: 'h2', parent_id: h1.id
    h3 = @structure.add_hierarchy name: 'h3', parent_id: h2.id
    h4 = @structure.add_hierarchy name: 'h4', parent_id: h1.id
    h5 = @structure.add_hierarchy name: 'h5', parent_id: h4.id
    h6 = @structure.add_hierarchy name: 'h6', parent_id: h4.id
    h7 = @structure.add_hierarchy name: 'h7', parent_id: h1.id
    h8 = @structure.add_hierarchy name: 'h8', parent_id: h7.id
    h9 = @structure.add_hierarchy name: 'h9', parent_id: h7.id
    @structure.to_json
  end
end

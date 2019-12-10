require 'sinatra'
require 'sinatra/contrib/all'
require 'pg'

require_relative ('./models/customer')
require_relative ('./models/film')
require_relative ('./models/ticket')
also_reload('./models/*')

get '/' do
  @films_list = Film.all
  erb(:index)
end

get '/film/:id' do
  film_id = params["id"].to_i
  @film = Film.find_by_id(film_id)
  erb(:film)
end

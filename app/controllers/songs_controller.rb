require 'rack-flash'

class SongsController < ApplicationController
  use Rack::Flash
  
  get '/songs' do
    @songs = Song.all
    erb :'/songs/index'
  end

  get '/songs/new' do
    @genres = Genre.all.sort_by(&:name)
    erb :'/songs/new'
  end

  post '/songs' do

    @song = Song.create(name: params[:song_name])

    if params[:artist_name] != ""
      @song.artist= Artist.create(name: params[:artist_name])
    end
    params[:genres].each do |genre_id|
      SongGenre.create(song_id: @song.id, genre_id: genre_id.to_i)
    end
  #  binding.pry
    @song.save
    flash[:message] = "Successfully created song."
    redirect "/songs/#{@song.slug}"
  end

  get '/songs/:slug' do

    @song = Song.all.find_by_slug(params[:slug].to_s)
    erb :'/songs/show'
  end
end

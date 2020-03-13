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
      @song.artist= Artist.find_or_create_by(name: params[:artist_name])
    end
    params[:genres].each do |genre_id|
      @song.genres << Genre.find(genre_id)
    end
    #params[:genres].each do |genre_id|
    #  SongGenre.create(song_id: @song.id, genre_id: genre_id.to_i)
    #end

    @song.save
    flash[:message] = "Successfully created song."
    redirect "/songs/#{@song.slug}"
  end

  get '/songs/:slug' do

    @song = Song.find_by_slug(params[:slug].to_s)
    erb :'/songs/show'
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug].to_s)

    if @song.artist == nil
      @artist_name = ""
    else
      @artist_name = @song.artist.name
    end
    erb :'/songs/edit'
  end

  patch '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug].to_s)
    @song.name = params[:song_name]
    @song.artist = Artist.find_or_create_by(name: params[:artist_name])
    @song.genres = []
    if params[:genres] != nil
        params[:genres].each do |genre_id|
        @song.genres << Genre.find(genre_id)
      end
    end
    @song.save
      flash[:message] = "Successfully updated song."
    redirect "songs/#{@song.slug}"

  end

end

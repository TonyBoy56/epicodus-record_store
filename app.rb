require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('./lib/artist')
require('pry')
require('./lib/song')
require('pg')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "record_store"})

#  Album Routes #

get('/') do
  @albums = Album.sort
  erb(:albums) #erb file name
end

get('/albums') do
  @albums = Album.sort
  erb(:albums)
end

get('/albums/new') do
  erb(:new_album)
end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get('/albums/search') do
  @album = Album.search(params[:name])
  erb(:search)
end

post('/albums') do 
  name = params[:album_name]
  artist = params[:album_artist]
  year = params[:album_year]
  genre = params[:album_genre]
  album = Album.new(name, nil, artist, genre, year)
  album.save()
  @albums = Album.all()
  erb(:albums)
end

get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new(params[:song_name], @album.id, nil, [:songwriter])
  # songwriter = Song.new(params[:songwriter_name], @album.id, nil)
  song.save()
  # songwriter.save()
  erb(:album)
end

patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

patch('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name])
  @albums = Album.all
  erb(:albums)
end

delete('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  @albums = Album.all
  erb(:albums)
end

get('/custom_route') do
  "We can even create custom routes, but we should only do this when needed."
end

# Artist Routes #

get('/artists') do
  @artists = Artist.all()
  erb(:artists)
end

get('/artists/new_artist') do
  erb(:new_artist)
end

get('/artists/:id') do
end

post('/artists') do
  name = params[:name]
  artist = Artist.new({name: name, id: nil})
  artist.save()
  @artists = Artist.all()
  erb(:artists)
end

patch('/artists/:id') do
end

delete('/artists/:id') do
end
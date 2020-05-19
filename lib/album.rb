require 'pry'

class Album

  attr_reader :id 
  attr_accessor :name, :genre, :year


  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id) 
    @genre = attributes.fetch(:genre) 
    @year = attributes.fetch(:year)
  end

  def self.all
    # Selet all items in our albums table #
    returned_albums = DB.exec("SELECT * FROM albums;")
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      genre = album.fetch("genre")
      year = album.fetch("year")
      albums.push(Album.new({:name => name, :id => id, :genre => genre, :year => year}))
    end
    albums
  end

  def self.all_sold
    @@sold_albums.values()
  end

  def save
    result = DB.exec("INSERT INTO albums (name, genre, year) VALUES ('#{@name}', '#{@genre}', '#{@year}') RETURNING id;")
      @id = result.first().fetch("id").to_i
  end

  def ==(album_to_compare)
    self.name() == album_to_compare.name()
  end

  def self.clear
    DB.exec("DELETE FROM albums *;")
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums  WHERE id = #{id};").first
    name = album.fetch("name")
    id = album.fetch("id").to_i
    genre = album.fetch("genre")
    year = album.fetch("year")
    Album.new({:name => name, :id => id, :genre => genre, :year => year})
  end

  def update(name)
    @name = name
    DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
  end

  def delete()
    # @@albums.delete(self.id)
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
    DB.exec("DELETE FROM songs WHERE album_id = #{@id};")
  end

  def self.search(name)
    album_names = Album.all.map {|a| a.name }
    result = []
    names = album_names.grep(/#{name}/)
    names.each do |n| 
      display_albums = Album.all.select {|a| a.name == n}
      result.push(display_albums)
    end
    result
  end

  def self.sort
    record_list = self.all
    sorted_records = record_list.sort_by{ |record| record.name }
    sorted_records
  end

  def songs
    Song.find_by_album(self.id)
  end
end


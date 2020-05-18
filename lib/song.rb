class Song
  attr_reader :id
  attr_accessor :name, :album_id, :songwriter

  @@songs = {}
  @@total_rows = 0

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @album_id = attributes.fetch(:album_id)
    @id = attributes.fetch(:id) || @@total_rows += 1
    @songwriter = attributes.fetch(:songwriter)
  end

  def ==(song_to_compare)
    if song_to_compare != nil
      (self.name() == song_to_compare.name()) && (self.album_id() == song_to_compare.album_id())
    else
      false
    end
  end

  def self.all
    # @@songs.values
    returned_songs = DB.exec("SELECT * FROM songs;")
    songs = []
    returned_songs.each() do |song|
      name = song.fetch("name")
      album_id = song.fetch("album_id").to_i
      id = song.fetch("id").to_i
      songwriter = song.fetch("songwriter")
      songs.push(Song.new({:name => name, :album_id => album_id, :id => id, :songwriter => songwriter}))
    end
    songs
  end

  def save
    result = DB.exec("INSERT INTO songs (name, album_id, songwriter) VALUES ('#{@name}', #{@album_id}, '#{@songwriter}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.find(id)
    # @@songs[id]
    song = DB.exec("SELECT * FROM songs WHERE id = #{id};").first
    if song
      name = song.fetch("name")
      album_id = song.fetch("album_id").to_i
      id = song.fetch("id").to_i
      Song.new({:name => name, :album_id => album_id, :id => id, :songwriter => songwriter})
    else
      nil
    end
  end

  
  def update(name, album_id)
    # self.name = name
    # self.album_id = album_id
    # @@songs[self.id] = Song.new(self.name, self.album_id, self.id, self.songwriter)
    @name = name
    @album_id = album_id
    DB.exec("UPDATE songs SET name = '#{@name}', album_id = #{@album_id} WHERE id = #{@id};")
  end
  
  def delete
    # @@songs.delete(self.id)
    DB.exec("DELETE FROM songs WHERE id = #{@id};")
  end
  
  def self.clear
    # @@songs = {}
    DB.exec("DELETE FROM songs *;")
  end

  def self.find_by_album(alb_id)
    songs = []
    returned_songs = DB.exec("SELECT * FROM songs WHERE album_id = #{alb_id};")
    returned_songs.each() do |song|
      name = song.fetch("name")
      id = song.fetch("id").to_i
      songs.push(Song.new({:name => name, :album_id => alb_id, :id => id, :songwriter => @songwriter}))
    end
    songs
  end

  def album
    Album.find(@album_id)
  end
end
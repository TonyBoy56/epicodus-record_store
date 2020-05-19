require('spec_helper')
require 'album'
require 'song'
require 'pry'

describe '#Artist' do

  describe('#save') do
    it("saves an artist") do
      artist = Artist.new({:name => "John Coltrane", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Rando", :id => nil})
      artist2.save()
      expect(Artist.all).to(eq([artist, artist2]))
    end
  end

  describe('.all') do
    it("returns an empty array when there are no albums") do
      expect(Artist.all).to(eq([]))
    end
  end

  describe('.clear') do
    it("clears all albums") do
      artist = Artist.new({:name => "Axel Rose", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Will Smith", :id => nil})
      artist2.save()
      Artist.clear()
      expect(Artist.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same album if it has the same attributes as another album") do
      artist = Artist.new({:name => "Axel Rose", :id => nil})
      artist2 = Artist.new({:name => "Axel Rose", :id => nil})
      expect(artist).to(eq(artist2))
    end
  end

  describe('.find') do
    it("finds an artist by id") do
      artist = Artist.new({:name => "Axel Rose", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "Will Smith", :id => nil})
      artist2.save()
      expect(Artist.find(artist.id)).to(eq(artist))
    end
  end
  
  describe('#update') do
    it("updates an artist by id") do
      artist = Artist.new({:name => "Axel Rose", :id => nil})
      artist.save()
      artist.update("Will Smith")
      expect(artist.name).to(eq("Will Smith"))
    end
  end

  describe('#delete') do
    it("deletes an artist by id") do
      artist = Artist.new({:name => "Axel Rose", :id => nil})
      artist.save()
      artist2 = Artist.new({:name => "James Hetfield", :id => nil})
      artist2.save()
      artist.delete()
      expect(Artist.all).to(eq([artist2]))
    end
  end

  describe('initialize') do
    it('tests for an Artist name') do
      artist = Artist.new({:name => "Axel Rose", :id => nil})
      artist.save()
      expect(artist.name).to(eq("Axel Rose"))
    end
  end
end
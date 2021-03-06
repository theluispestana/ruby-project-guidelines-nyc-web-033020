class Artist < ActiveRecord::Base
  has_many :albums
  has_many :favorites
  has_many :users, through: :favorites

  def self.api_call(user_input)
    artist_inst = Artist.find_by(name: "#{user_input.titleize}")
    if artist_inst
      artist_inst
    else
      url = "https://api.musixmatch.com/ws/1.1/artist.search?q_artist=#{user_input}&page_size=5&apikey=#{ENV["api_key"]}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
      return puts "That artist was not found" if data["message"]["header"]["available"]  == 0
      artist = data["message"]["body"]["artist_list"][0]["artist"]
      artist_inst = Artist.create(name: artist["artist_name"], artist_id: artist["artist_id"], artist_rating: artist["artist_rating"], country: artist["artist_country"])
      artist_inst.top_albums
    end
    artist_inst
  end

  def top_albums
    url = "https://api.musixmatch.com/ws/1.1/artist.albums.get?artist_id=#{self.artist_id}&s_release_date=desc&apikey=#{ENV["api_key"]}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    i = 0
      3.times do
        album = data["message"]["body"]["album_list"][i]["album"]
        Album.create(name: album["album_name"], rating: album["album_rating"], release_date: album["album_release_date"], artist_id: self.id)
        i += 1
      end
  end

  def average_rating
    favorites = self.favorites.select { |fav| fav.user_rating != nil }
    ratings = favorites.map { |fav| fav.user_rating }
    (ratings.reduce { |acc, cur| acc + cur } / ratings.length.to_f).round(1)
  end
  
  def show_all_ratings_for_artist
    favorites = self.favorites.reload.select { |fav| fav.user_rating != nil }
    ratings = favorites.map { |fav| fav.user_rating }
    
    if ratings.length > 0
      ratings.each do |rating|
        puts "  #{rating}/10"
      end
      puts "The average user rating is #{average_rating}"
      puts "The rating from musixmatch is #{self.artist_rating}"
    else
      puts "There are no user ratings for this artist at this time"
      puts "The rating from musixmatch is #{self.artist_rating}"
    end
  end

  def display_album_info
    i = 1
    self.albums.reload.each do |album| 
      puts " #{i}. Name: #{album.name} | Rating: #{album.rating} | Release date: #{album.release_date}" 
      i += 1
    end
  end
end


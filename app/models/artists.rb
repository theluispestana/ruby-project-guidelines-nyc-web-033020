class Artist < ActiveRecord::Base
  has_many :albums
  has_many :favorites
  has_many :users, through: :favorites

  def self.api_call(user_input)
    artist = Artist.find_by(name: "#{user_input.titleize}")
    if artist
      artist
    else
      url = "https://api.musixmatch.com/ws/1.1/artist.search?q_artist=#{user_input}&page_size=5&apikey=#{ENV["api_key"]}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
      return puts "That artist was not found" if data["message"]["header"]["available"]  == 0
      artist = data["message"]["body"]["artist_list"][0]["artist"]
      Artist.create(name: artist["artist_name"], artist_id: artist["artist_id"], artist_rating: artist["artist_rating"], country: artist["artist_country"])
    end
  end

end


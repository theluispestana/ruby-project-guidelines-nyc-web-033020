def welcome
  puts "Please enter your name"
  username = gets.chomp
  puts "Welcome #{username}."
  User.find_or_create_by(name: username)
end

def display_commands 
  cmd = command_hash
  cmd[0].each { |k, v| puts v }

end

def search_for_artist
  puts "Please search for an artist" 
  user_artist_search = gets.chomp.downcase
end

def artist_api_call(user_input)
  artist = Artist.find_by(name: "#{user_input.titleize}")
  if artist
    artist
  else
    url = "https://api.musixmatch.com/ws/1.1/artist.search?q_artist=#{user_input}&page_size=5&apikey=#{ENV["api_key"]}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    artist = data["message"]["body"]["artist_list"][0]["artist"]
    Artist.create(name: artist["artist_name"], artist_id: artist["artist_id"], artist_rating: artist["artist_rating"], country: artist["artist_country"])
  end

  #Artist.find_or_create_by(name: artist["artist_name"]) do |artist|
    #artist.artist_id = 10 
    #artist.artist_rating = artist["artist_rating"]
    #artist.country = artist["artist_country"]
  #end
end

def command_hash
  # { 
  #   add_artist: "Add artist to favorites",
  #   show_my_favs: "Show my favorite artists",
  #   show_ratings: "Show my ratings",
  #   show_albums: "Show an artists albums",
  #   delete_favs: "Delete all artists from my favorites",
  #   delete_artist: "Delete artist from favorite",
  #   change_rating: "Change artist Rating",
  #   q: "quit"
  # }
  [
    {
      fav: "favorite",
      q: "quit",
      info: "information about artist"
    }
  ]
end

def check_user_input
  user_input = gets.chomp
end

def start_app
  user_input = ''
  until user_input == "quit" || user_input == "exit" do
    user_input = search_for_artist
    artist_api_call(user_input)
    display_commands
    puts "Please Enter a valid command" 
    user_input = "quit"
  end
end

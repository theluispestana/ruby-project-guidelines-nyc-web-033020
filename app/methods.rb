def welcome
  puts "Please enter your name"
  username = gets.chomp
  puts "Welcome #{username}."
  User.find_or_create_by(name: username) 
end

def display_commands 
  puts ''
  puts "Please Enter a valid command"
  cmd = command_hash
  n = 1
  cmd[:first_set_of_commands].each do |k, v| 
    puts "  #{n}. #{v}" 
    n += 1
  end
end

def ask_for_artist_input
  puts "Please search for an artist" 
  user_artist_search = gets.chomp.downcase
end

# def artist_api_call(user_input)
#   artist = Artist.find_by(name: "#{user_input.titleize}")
#   if artist
#     artist
#   else
#     url = "https://api.musixmatch.com/ws/1.1/artist.search?q_artist=#{user_input}&page_size=5&apikey=#{ENV["api_key"]}"
#     uri = URI(url)
#     response = Net::HTTP.get(uri)
#     data = JSON.parse(response)
#     return puts "That artist was not found" if data["message"]["header"]["available"]  == 0
#     artist = data["message"]["body"]["artist_list"][0]["artist"]
#     Artist.create(name: artist["artist_name"], artist_id: artist["artist_id"], artist_rating: artist["artist_rating"], country: artist["artist_country"])
#   end
# end

# def find_or_create_favorite(user_id, artist)
#   favorite = Favorite.where(["user_id = ? and artist_id = ?", user_id, artist.id])
#   if favorite.length > 0
#     favorite
#   else
#     Favorite.create(user_id: user_id, artist_id: artist.id, artist_name: artist.name)
#   end
# end

def command_hash
  {
    first_set_of_commands: {
      fav: "favorite",
      info: "information about artist",
      my_favs: "show my favorites",
      search: "search for another artist",
      q: "quit"
    }
  }
end

def check_user_input
  user_input = gets.chomp
end

def search_for_artist
  artist = ''
  loop do
    user_input = ask_for_artist_input
    artist = Artist.api_call(user_input)
    break if artist
  end
  artist
end

def start_app(user, artist)
  loop do
    display_commands
    print "     > "
    user_input = gets.chomp
    cmd = command_hash[:first_set_of_commands]
    if user_input == cmd[:q] || user_input == "5"
      break
    elsif user_input == cmd[:fav] || user_input == "1"
      Favorite.find_or_create(user.id, artist)
    elsif user_input == cmd[:search] || user_input == "4"
      artist = search_for_artist
    elsif user_input == cmd[:my_favs] || user_input == "3"
      # Favorite.all.each { |fav| puts "  -- #{fav.artist_name}" }
      puts user.favorites.length
      user.show_my_favs
      puts user.favorites.length
    elsif user_input == cmd[:info] || user_input == "2"
      puts "Artist Name: #{artist.name}, Artist's Country: #{artist.country}, Artist's Rating: #{artist.artist_rating}"
    else
      puts "That command was not recognized"
    end
  end
end

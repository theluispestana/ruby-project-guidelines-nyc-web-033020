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
  user_artist_search = gets.chomp.titleize
end

def artist_api_call
  url = "https://api.musixmatch.com/ws/1.1/artist.search?q_artist=arctic%20monkeys&page_size=5&apikey=env[api_key]"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  binding.pry
  JSON.parse(response.body)
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

def check_for_input
  user_input = ''
  until user_input == "quit" || user_input == "exit" do
    display_commands
    puts "Please Enter a valid command" 
    user_input = "quit"
  end
end

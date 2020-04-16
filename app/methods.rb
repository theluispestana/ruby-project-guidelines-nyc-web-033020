def welcome
  puts "Please enter your name"
  username = gets.strip.chomp
  puts "Welcome #{username}."
  User.find_or_create_by(name: username) 
end

def display_commands(set_of_commands)
  puts ''
  puts "Please Enter a valid command"
  cmd = command_hash
  n = 1
  cmd[set_of_commands].each do |k, v| 
    puts "  #{n}. #{v}" 
    n += 1
  end
end

def ask_for_artist_input
  puts "Please search for an artist" 
  user_artist_search = gets.chomp.downcase
end

def command_hash
  {
    primary_commands: {
      fav: "favorite",
      info: "information about artist",
      albums: "artist's latest releases",
      my_favs: "show my favorites",
      search: "search for another artist",
      q: "quit"
    },
    rating_commands: {
      rate: "Rate artist",
      all_rating: "Show all ratings for this artist",
      my_ratings: "Show all of your ratings",
      q: "Don't rate"
    }
  }
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

def add_rating(favorite, artist, user)
  display_commands(:rating_commands)
  print "     > "
  input = gets.chomp
  cmd = command_hash[:rating_commands]
  if input == cmd[:rate] || input == "1"
    loop do
      puts "Please enter rating from 1-10"
      rating = gets.chomp.to_i
      if rating > 0 && rating < 11
        favorite.update(user_rating: rating)
        break
      else
        puts "That rating was invalid"
      end
    end
  elsif input == cmd[:all_rating] || input == "2"
    artist.show_all_ratings_for_artist
  elsif input == cmd[:my_ratings] || input == "3"
    user.my_ratings
  elsif input == cmd[:q] || input == "4"
    puts "go back to loop"
  else
    puts "That command was not recognized"
  end
end

def start_app(user, artist)
  loop do
    display_commands(:primary_commands)
    print "     > "
    user_input = gets.chomp
    cmd = command_hash[:primary_commands]
    if user_input == cmd[:q] || user_input == "6"
      break
    elsif user_input == cmd[:fav] || user_input == "1"
      favorite = Favorite.find_or_create(user.id, artist)
      add_rating(favorite, artist, user)
    elsif user_input == cmd[:search] || user_input == "5"
      artist = search_for_artist
    elsif user_input == cmd[:my_favs] || user_input == "4"
      user.show_my_favs
    elsif user_input == cmd[:info] || user_input == "2"
      puts "Artist Name: #{artist.name}, Artist's Country: #{artist.country}, Artist's Rating: #{artist.artist_rating}"
    elsif user_input == cmd[:albums] || user_input == "3"
      artist.display_album_info
    else
      puts "That command was not recognized"
    end
  end
end

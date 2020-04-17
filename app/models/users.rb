class User < ActiveRecord::Base
has_many :favorites
has_many :artists, through: :favorites

def show_my_favs
  current_favs = self.favorites.reload
    if current_favs.length > 0
      current_favs.each {|fav| puts "  -- #{fav.artist_name}"}
    else
      puts "  -- You have no favorites at this time"
    end
end

    def my_ratings
        favorites = self.favorites.reload.select { |fav| fav.user_rating != nil }
        ratings = favorites.map { |fav| fav.user_rating }
        # binding.pry
        if ratings.length > 0
            favorites.each do |favorite|
                puts "  -- #{favorite.artist_name}: #{favorite.user_rating}"
            end
        else
            puts "You do not have any ratings at this time"
        end
    end
end
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
        self.favorites.reload.each do |favorite|
            puts "  -- #{favorite.artist_name}: #{favorite.user_rating}" if favorite.user_rating != nil
        end
    end
end
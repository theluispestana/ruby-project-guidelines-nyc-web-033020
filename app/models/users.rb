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
end
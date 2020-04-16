class User < ActiveRecord::Base
has_many :favorites
has_many :artists, through: :favorites

def show_my_favs
    # if self.favorites.length == 0
    #     puts "  -- You have no favorites at this time"
    # else
    #     self.favorites.each {|fav| puts "  -- #{fav.artist_name}"}
    # end
        arr_length = self.favorites.length
        # puts arr_length
        if self.favorites.length > 0
            self.favorites.each {|fav| puts "  -- #{fav.artist_name}"}
        else
            puts "  -- You have no favorites at this time"
        end
        # puts arr_length
    end
end
class Favorite < ActiveRecord::Base
belongs_to :artist
belongs_to :user
attr_accessor :user_rating

    def self.find_or_create(user_id, artist)
        favorite = Favorite.where(["user_id = ? and artist_id = ?", user_id, artist.id])
        if favorite.length > 0
            favorite
        else
            Favorite.create(user_id: user_id, artist_id: artist.id, artist_name: artist.name)
        end
    end

    def self.show_all_favs
        Favorite.all.each { |fav| puts "  -- #{fav.artist_name}" }
    end
end

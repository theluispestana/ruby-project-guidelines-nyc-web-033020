class AddArtistNameColumnToFav < ActiveRecord::Migration[6.0]
  def change
    add_column :favorites, :artist_name, :string
  end
end

class ChangeAlbumColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :albums, :track_count
    remove_column :albums, :genre
    change_column :albums, :release_date, :date
  end
end

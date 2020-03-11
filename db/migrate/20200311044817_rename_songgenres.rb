class RenameSonggenres < ActiveRecord::Migration[5.2]
  def change
    rename_table :songgenres, :song_genres
  end
end

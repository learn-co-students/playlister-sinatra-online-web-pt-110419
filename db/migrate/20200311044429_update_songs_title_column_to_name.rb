class UpdateSongsTitleColumnToName < ActiveRecord::Migration[5.2]
  def change
    rename_column :songs, :title, :name
  end
end

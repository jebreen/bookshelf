class MakeGenreIdNullableOnGenreTable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :genres, :genre_id, true
  end
end

class AddGenreToBook < ActiveRecord::Migration[6.1]
  def change
    add_reference :books, :genre, foreign_key: true, optional: true
  end
end

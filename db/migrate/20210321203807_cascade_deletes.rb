class CascadeDeletes < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :author_books, :books
    add_foreign_key :author_books, :books, dependent: :delete
    remove_foreign_key :author_books, :authors
    add_foreign_key :author_books, :authors, dependent: :delete
  end
end

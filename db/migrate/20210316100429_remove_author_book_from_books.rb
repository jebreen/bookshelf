class RemoveAuthorBookFromBooks < ActiveRecord::Migration[6.1]
  def change
    remove_column :books, :author_book
  end
end

class CreateGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :genres do |t|
      t.text :description
      t.boolean :fiction
      t.belongs_to :genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :authors do |t|
      t.string :lsat_name
      t.string :first_name
      t.string :other_names

      t.timestamps
    end
  end
end

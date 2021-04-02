class ChangeAuthorColumnLsatNameToLastName < ActiveRecord::Migration[6.1]
  def change
    change_column :authors, :lsat_name, :string
  end
end

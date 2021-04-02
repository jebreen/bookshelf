class ChangeAuthorColumnLsatNameToLastNameCorrected < ActiveRecord::Migration[6.1]
  def change
    rename_column :authors, :lsat_name, :last_name
    change_column :authors, :last_name, :string
  end
end

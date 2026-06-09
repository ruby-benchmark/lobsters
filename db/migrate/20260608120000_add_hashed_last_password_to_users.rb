class AddHashedLastPasswordToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :hashed_last_password, :string, limit: 40
  end
end

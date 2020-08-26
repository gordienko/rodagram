class CreateUserAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :user_addresses do |t|
      t.inet :ip, null: false, index: true
      t.belongs_to :user, null: false, foreign_key: { on_delete: :cascade }
    end
    add_index :user_addresses, [:ip, :user_id], unique: true
  end
end

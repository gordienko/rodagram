class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :body, null: false
      t.belongs_to :user, null: false, foreign_key: { on_delete: :cascade }
      t.inet :creator_ip, null: false, index: true
      t.decimal :average_rating, default: 0, mull: false, precision: 25, scale: 16, index: true
      t.integer :sum_rating, default: 0, mull: false
      t.integer :rates_count, default: 0, mull: false
      t.timestamps
    end
    add_index :posts, [:average_rating, :rates_count]
  end
end

class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.belongs_to :post, null: false, foreign_key: { on_delete: :cascade }
      t.integer :value, null: false
      t.timestamps
    end
  end
end

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.string :category
      t.integer :weight
      t.integer :volume

      t.timestamps
    end
  end
end

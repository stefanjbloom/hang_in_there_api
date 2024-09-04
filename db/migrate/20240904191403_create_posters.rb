class CreatePosters < ActiveRecord::Migration[7.1]
  def change
    create_table :posters do |t|
      t.string :name
      t.string :description
      t.float :price
      t.integer :year
      t.boolean :vintage
      t.string :img_url

      t.timestamps
    end
  end
end

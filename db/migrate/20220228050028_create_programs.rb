class CreatePrograms < ActiveRecord::Migration[7.0]
  def change
    create_table :programs do |t|
      t.string :title
      t.integer :rating, min: 1, max: 5
      t.references :characters, foreign_key: true
      t.references :genres, foreign_key: true

      t.timestamps
    end
  end
end

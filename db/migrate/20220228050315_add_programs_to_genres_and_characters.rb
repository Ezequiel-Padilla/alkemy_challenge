class AddProgramsToGenresAndCharacters < ActiveRecord::Migration[7.0]
  def change
    add_reference :genres, :program, foreign_key: true
    add_reference :characters, :program, foreign_key: true
  end
end

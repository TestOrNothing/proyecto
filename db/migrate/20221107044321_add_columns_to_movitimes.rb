class AddColumnsToMovitimes < ActiveRecord::Migration[7.0]
  def change
    add_column :movie_times, :location, :string
    add_column :movie_times, :lenguage, :string
  end
end

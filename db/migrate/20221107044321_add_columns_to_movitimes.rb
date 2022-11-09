# frozen_string_literal: true

class AddColumnsToMovitimes < ActiveRecord::Migration[7.0]
  def change
    change_table :movie_times, bulk: true do |t|
      t.string :location
      t.string :lenguage
    end
  end
end

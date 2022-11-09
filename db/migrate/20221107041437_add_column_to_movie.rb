# frozen_string_literal: true

class AddColumnToMovie < ActiveRecord::Migration[7.0]
  def change
    add_column :movies, :restricted, :boolean
  end
end

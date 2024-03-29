# frozen_string_literal: true

class AddCurrenciesTable < ActiveRecord::Migration[4.2]
  def change
    create_table :currencies do |t|
      t.belongs_to :country, foreign_key: true
      t.string :currency_code

      t.timestamps
    end
  end
end

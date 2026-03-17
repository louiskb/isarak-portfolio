class ChangeYearToStringOnTeachings < ActiveRecord::Migration[8.1]
  def change
    change_column :teachings, :year, :string
  end
end

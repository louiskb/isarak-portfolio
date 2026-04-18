class ChangeYearToStringOnGrantAwards < ActiveRecord::Migration[8.1]
  def change
    change_column :grant_awards, :year, :string
  end
end

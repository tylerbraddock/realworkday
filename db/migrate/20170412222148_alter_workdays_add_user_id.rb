class AlterWorkdaysAddUserId < ActiveRecord::Migration[5.0]
  def change
    add_column :workdays, :user_id, :integer
    add_index :workdays, :user_id
  end
end

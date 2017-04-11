class CreateWorkdays < ActiveRecord::Migration[5.0]
  def change
    create_table :workdays do |t|
      t.string :job_title
      t.string :industry
      t.text :description
      t.timestamps
    end
  end
end

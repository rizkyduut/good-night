class CreateSleepRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.datetime :clock_in, null: false
      t.datetime :clock_out
      t.integer :duration, index: true
      t.timestamps
    end

    add_index :sleep_records, [:user_id, :clock_in]
  end
end

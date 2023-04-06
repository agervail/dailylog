class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :EventType, limit: 100
      t.date :date

      t.timestamps
    end
  end
end

class CreateBeds < ActiveRecord::Migration[7.0]
  def change
    create_table :beds do |t|
      t.references :room, null: false, foreign_key: true
      t.integer :bed_size

      t.timestamps
    end
  end
end

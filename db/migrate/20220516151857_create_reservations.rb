class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :listing, null: false, foreign_key: true
      t.string :session_id
      t.references :guest, null: false, foreign_key: { to_table: :users }
      t.integer :status

      t.timestamps
    end
  end
end

class CreateUserFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_files do |t|
      t.references :user, null: false, foreign_key: true
      t.string :asset, null: false
      t.integer :file_size, null: false, default: 0

      t.timestamps
    end
  end
end

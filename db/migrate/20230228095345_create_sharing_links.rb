class CreateSharingLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :sharing_links, primary_key: :digest, id: :string do |t|
      t.references :user_file, type: :uuid, null: false, foreign_key: true
      t.datetime :expire_at

      t.timestamps
    end
  end
end

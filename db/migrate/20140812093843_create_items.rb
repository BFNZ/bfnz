class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.string :author
      t.string :code, unique: true, null: false
      t.string :image_path
      t.string :description, limit: 1000
      t.datetime :deactivated_at

      t.timestamps
    end
  end
end

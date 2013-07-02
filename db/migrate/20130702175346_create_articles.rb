class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text   :description, null: false
      t.string :url
      t.references :category
      t.timestamps
    end
  end
end

class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.text :comment
      t.references :track, index: true

      t.timestamps
    end
  end
end

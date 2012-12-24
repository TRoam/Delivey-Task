class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :checkman_id
      t.string  :commenter
      t.text    :content
      t.string  :feedback ,:default =>"open"
      
      t.timestamps
    end
  end
end
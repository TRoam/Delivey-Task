class ChangeEidToPeople < ActiveRecord::Migration
  def up
    change_column :people,:eid,:string
  end

  def down
  end
end

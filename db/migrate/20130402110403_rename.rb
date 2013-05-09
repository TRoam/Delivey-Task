class Rename < ActiveRecord::Migration
  def change
    rename_column :testplans, :type ,:test_type
  end
end

class AddPasswordToContents < ActiveRecord::Migration
  def change
    add_column :contents, :password, :string
  end
end

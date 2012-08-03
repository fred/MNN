class AddRelToLinks < ActiveRecord::Migration
  def change
    add_column :links, :rel, :string
    add_column :links, :rev, :string
    add_column :pages, :rel, :string
    add_column :pages, :rev, :string
  end
end
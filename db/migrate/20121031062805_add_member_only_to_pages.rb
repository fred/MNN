class AddMemberOnlyToPages < ActiveRecord::Migration
  def change
    add_column :pages, :member_only, :boolean, default: false
  end
end

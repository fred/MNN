class AddConfirmableToUsers < ActiveRecord::Migration
  def change
    User.where(confirmed_at: nil).update_all(confirmed_at: Time.now)
  end
end

class AddUserToTeamMembers < ActiveRecord::Migration[5.0]
  def change
    add_reference :team_members, :user, foreign_key: true
  end
end

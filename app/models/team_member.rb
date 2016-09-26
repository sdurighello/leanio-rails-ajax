class TeamMember < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates :user, inclusion: { :in => :project_users,
    message: "%{value} is not a project user" }, :allow_nil => true


  private

  def project_users
    self.team.project.users
  end

end

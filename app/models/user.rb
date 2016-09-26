class User < ApplicationRecord

  has_and_belongs_to_many :projects
  has_many :team_members, dependent: :destroy

  def all_projects_for_user
    (self.projects + Project.where(created_by: self.id)).uniq
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

class User < ApplicationRecord

  has_and_belongs_to_many :projects

  def all_projects_for_user
    self.projects + Project.where(created_by: self.id)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

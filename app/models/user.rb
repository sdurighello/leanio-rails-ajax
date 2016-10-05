class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  include ExampleData # method "populate_data(user)" is now available

  has_many :created_projects, class_name: "Project", foreign_key: "created_by_id", dependent: :destroy
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :experiments

  after_create :populate_example_data

  def all_projects_for_user
    (self.projects + self.created_projects).uniq
  end

  private

  def populate_example_data
    populate_data(self)
  end


end

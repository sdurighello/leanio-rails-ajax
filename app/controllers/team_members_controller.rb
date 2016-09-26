class TeamMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_member
  before_action :set_project
  before_action :set_team
  before_action :set_team_member, except: [:index, :new, :create]
  before_action :project_is_active, except: [:index, :show]

  add_breadcrumb "Projects", :projects_path

  # GET /team_members
  # GET /team_members.json
  def index
    @team_members = TeamMember.where(team_id: params[:team_id])
  end

  # GET /team_members/1
  # GET /team_members/1.json
  def show
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Team: #{@team.name}", project_team_path(@project, @team)
    add_breadcrumb "Team member: #{@team_member.user.name}", project_team_team_member_path(@project, @team, @team_member)
  end

  # GET /team_members/new
  def new
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Team: #{@team.name}", project_team_path(@project, @team)
    add_breadcrumb "New team member"
    @team_member = TeamMember.new
  end

  # GET /team_members/1/edit
  def edit
  end

  # POST /team_members
  # POST /team_members.json
  def create
    @team_member = TeamMember.new(team_member_params)

    respond_to do |format|
      if @team_member.save
        format.html { redirect_to project_team_member_path(@project.id, @team_member), notice: 'Team member was successfully created.' }
        format.json { render :show, status: :created, location: @team_member }
      else
        format.html { render :new }
        format.json { render json: @team_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team_members/1
  # PATCH/PUT /team_members/1.json
  def update
    respond_to do |format|
      if @team_member.update(team_member_params)
        format.html { redirect_to project_team_member_path(@project.id, @team_member), notice: 'Team member was successfully updated.' }
        format.json { render :show, status: :ok, location: @team_member }
      else
        format.html { render :edit }
        format.json { render json: @team_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /team_members/1
  # DELETE /team_members/1.json
  def destroy
    @team_member.destroy
    respond_to do |format|
      format.html { redirect_to project_team_members_path(@project.id), notice: 'Team member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def user_is_member
      project = Project.find(params[:project_id])
      unless (current_user.id == project.created_by) || (project.users.any? { |u| u.id == current_user.id  })
        flash[:error] = "You are not a member of this project"
        redirect_to projects_path, notice: 'You are not a member of this project' # halts request cycle
      end
    end
    def project_is_active
      project = Project.find(params[:project_id])
      team = Team.find(params[:team_id])
      team_member = TeamMember.find(params[:id]) if params[:id].present?
      unless project.active
        flash[:error] = "This project is not active"
        if params[:id].present?
          redirect_to project_team_team_member_path(project.id, team.id, team_member), notice: 'This project is not active' # halts request cycle
        else
          redirect_to project_team_path(project.id, team), notice: 'This project is not active'
        end
      end
    end
    def set_project
      @project = Project.find(params[:project_id])
    end
    def set_team
      @team = Team.find(params[:team_id])
    end
    def set_team_member
      @team_member = TeamMember.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_member_params
      params.require(:team_member).permit(:team_id, :user_id, :role)
    end
end

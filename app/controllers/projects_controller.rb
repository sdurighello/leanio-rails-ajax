class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_member, except: [:index, :new, :create]
  before_action :set_project, except: [:index, :new, :create]
  before_action :project_is_active, except: [:index, :new, :create, :show, :update_active_status]

  add_breadcrumb "Projects", :projects_path

  # Manage user members
  def show_users
    respond_to do |format|
      format.html
      format.js
    end
  end

  def search_users
    @found_users = @project.search_users(params[:search]) || []
    respond_to do |format|
      format.js
    end
  end

  def add_user
    if @project.add_user(params[:user_id].to_i, current_user.id)
      redirect_to project_path(id: @project.id, selected_tab: 4), notice: 'User was successfully added'
    else
      redirect_to project_path(id: @project.id, selected_tab: 4), notice: 'User cannot be added'
    end
  end

  def remove_user
    if @project.remove_user(params[:user_id].to_i, current_user.id)
      redirect_to project_path(id: @project.id, selected_tab: 4), notice: 'User was successfully removed'
    else
      redirect_to project_path(id: @project.id, selected_tab: 4), notice: 'User cannot be removed'
    end
  end

  # SET current phase
  def set_current_phase
    if @project.set_current_phase(params[:phase_id].to_i)
      redirect_to project_path(id: @project.id, selected_tab: 4), notice: 'Project was successfully updated'
    else
      redirect_to project_path(id: @project.id, selected_tab: 4), notice: 'Could not update the current phase'
    end
  end

  # UPDATE active status
  def update_active_status
    if @project.update_active_status(current_user.id)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      redirect_to @project, notice: 'Could not update the project'
    end
  end

  # GET /projects
  # GET /projects.json
  def index
    @show_search_bar = true
    @projects = current_user.all_projects_for_user
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
  end

  # GET /projects/new
  def new
    add_breadcrumb "New project"
    @project = Project.new
    @project.phases.build
  end

  # GET /projects/1/edit
  def edit
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to edit_project_phase_path(project_id: @project.id, id: @project.phases.last), notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def user_is_member
      project = Project.find(params[:id])
      unless (current_user.id == project.created_by.id) || (project.users.any? { |u| u.id == current_user.id  })
        flash[:error] = "You are not a member of this project"
        redirect_to projects_path, notice: 'You are not a member of this project' # halts request cycle
      end
    end
    def project_is_active
      project = Project.find(params[:id])
      unless project.active
        flash[:error] = "This project is not active"
        redirect_to project, notice: 'This project is not active' # halts request cycle
      end
    end
    def set_project
      @project = Project.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(
        :name, :description, :status, :active, :created_by_id,
        phases_attributes: [:id,:sequence, :start_date])
    end
end

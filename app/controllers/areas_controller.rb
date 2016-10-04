class AreasController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_member
  before_action :set_project
  before_action :set_canvas
  before_action :set_area, except: [:index, :new, :create]
  before_action :project_is_active, except: [:index, :show]

  add_breadcrumb "Projects", :projects_path

  # Adding / Removing hypotheses to/from experiments
  def add_hypothesis
    if @area.add_hypothesis(params[:hypothesis_id].to_i)
      redirect_to project_canvas_path(@project.id, @canvas), notice: 'Hypothesis was successfully added'
    else
      redirect_to project_canvas_path(@project.id, @canvas), notice: 'Hypothesis cannot be added'
    end
  end

  def remove_hypothesis
    if @area.remove_hypothesis(params[:hypothesis_id].to_i)
      redirect_to project_canvas_path(@project.id, @canvas), notice: 'Hypothesis was successfully removed'
    else
      redirect_to project_canvas_path(@project.id, @canvas), notice: 'Hypothesis cannot be removed'
    end
  end

  # GET /areas
  # GET /areas.json
  def index
    @areas = Area.where(canvas_id: params[:canvas_id])
  end

  # GET /areas/1
  # GET /areas/1.json
  def show
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Canvas: #{@canvas.name}", project_canvas_path(@project, @canvas)
    add_breadcrumb "Area: #{@area.name}", project_canvas_area_path(@project, @canvas, @area)

  end

  # GET /areas/new
  def new
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Canvas: #{@canvas.name}", project_canvas_path(@project, @canvas)
    add_breadcrumb "New area"
    @area = Area.new
  end

  # GET /areas/1/edit
  def edit
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Canvas: #{@canvas.name}", project_canvas_path(@project, @canvas)
    add_breadcrumb "Area: #{@area.name}", project_canvas_area_path(@project, @canvas, @area)
  end

  # POST /areas
  # POST /areas.json
  def create
    @area = Area.new(area_params)

    respond_to do |format|
      if @area.save
        format.html { redirect_to project_canvas_area_path(@project.id, @canvas.id, @area), notice: 'Area was successfully created.' }
        format.json { render :show, status: :created, location: @area }
      else
        format.html { render :new }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /areas/1
  # PATCH/PUT /areas/1.json
  def update
    respond_to do |format|
      if @area.update(area_params)
        format.html { redirect_to project_canvas_area_path(@project.id, @canvas.id, @area), notice: 'Area was successfully updated.' }
        format.json { render :show, status: :ok, location: @area }
      else
        format.html { render :edit }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /areas/1
  # DELETE /areas/1.json
  def destroy
    @area.destroy
    respond_to do |format|
      format.html { redirect_to project_canvas_path(@project.id, @canvas.id), notice: 'Area was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def user_is_member
      project = Project.find(params[:project_id])
      unless (current_user.id == project.created_by.id) || (project.users.any? { |u| u.id == current_user.id  })
        flash[:error] = "You are not a member of this project"
        redirect_to projects_path, notice: 'You are not a member of this project' # halts request cycle
      end
    end
    def project_is_active
      project = Project.find(params[:project_id])
      canvas = Canvas.find(params[:canvas_id])
      area = Area.find(params[:id]) if params[:id].present?
      unless project.active
        flash[:error] = "This project is not active"
        if params[:id].present?
          redirect_to project_canvas_area_path(project.id, canvas.id, area), notice: 'This project is not active' # halts request cycle
        else
          redirect_to project_canvas_path(project.id, canvas), notice: 'This project is not active'
        end
      end
    end
    def set_project
      @project = Project.find(params[:project_id])
    end
    def set_canvas
      @canvas = Canvas.find(params[:canvas_id])
    end
    def set_area
      @area = Area.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def area_params
      params.require(:area).permit(:canvas_id, {hypothesis_ids: []}, :name, :description, :area_identifier)
    end
end

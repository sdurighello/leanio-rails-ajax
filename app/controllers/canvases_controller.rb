class CanvasesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_member
  before_action :set_project
  before_action :set_canvas, except: [:index, :new, :create]
  before_action :project_is_active, except: [:index, :show]

  add_breadcrumb "Projects", :projects_path

  # GET /canvases
  # GET /canvases.json
  def index
    @canvases = Canvas.where(project_id: params[:project_id])
  end

  # GET /canvases/1
  # GET /canvases/1.json
  def show
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Canvas: #{@canvas.name}", project_canvas_path(@project, @canvas)
  end

  # GET /canvases/new
  def new
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "New Canvas"
    @canvas = Canvas.new
  end

  # GET /canvases/1/edit
  def edit
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Canvas: #{@canvas.name}", project_canvas_path(@project, @canvas)
  end

  # POST /canvases
  # POST /canvases.json
  def create
    @canvas = Canvas.new(canvas_params)

    respond_to do |format|
      if @canvas.save
        format.html { redirect_to project_canvas_path(@project.id, @canvas), notice: 'Canvas was successfully created.' }
        format.json { render :show, status: :created, location: @canvas }
      else
        format.html { render :new }
        format.json { render json: @canvas.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /canvases/1
  # PATCH/PUT /canvases/1.json
  def update
    respond_to do |format|
      if @canvas.update(canvas_params)
        format.html { redirect_to project_canvas_path(@project.id, @canvas), notice: 'Canvas was successfully updated.' }
        format.json { render :show, status: :ok, location: @canvas }
      else
        format.html { render :edit }
        format.json { render json: @canvas.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /canvases/1
  # DELETE /canvases/1.json
  def destroy
    @canvas.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project.id), notice: 'Canvas was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def project_is_active
      project = Project.find(params[:project_id])
      canvas = Canvas.find(params[:id]) if params[:id].present?
      unless project.active
        flash[:error] = "This project is not active"
        if params[:id].present?
          redirect_to project_canvas_path(project.id, canvas), notice: 'This project is not active' # halts request cycle
        else
          redirect_to project_path(project), notice: 'This project is not active'
        end
      end
    end
    def user_is_member
      project = Project.find(params[:project_id])
      unless (current_user.id == project.created_by) || (project.users.any? { |u| u.id == current_user.id  })
        flash[:error] = "You are not a member of this project"
        redirect_to projects_path, notice: 'You are not a member of this project' # halts request cycle
      end
    end
    def set_project
      @project = Project.find(params[:project_id])
    end
    def set_canvas
      @canvas = Canvas.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def canvas_params
      params.require(:canvas).permit(:project_id,
        :name, :description,
        :customers_to_break_even, :payback_period, :gross_margin,
        :market_size, :customer_pain_level, :market_ease_of_reach,
        :feasibility, :riskiness)
    end
end

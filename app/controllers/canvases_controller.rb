class CanvasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:index, :show, :new, :edit, :create, :update, :destroy]
  before_action :set_canvas, only: [:show, :edit, :update, :destroy]

  add_breadcrumb "Projects", :projects_path

  # GET /canvases
  # GET /canvases.json
  def index
    @canvases = Canvas..where(project_id: params[:project_id])
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
    add_breadcrumb "New Phase"
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
    def set_project
      @project = Project.find(params[:project_id])
    end
    def set_canvas
      @canvas = Canvas.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def canvas_params
      params.require(:canvas).permit(:project_id, :name, :description)
    end
end

class CanvasesController < ApplicationController
  before_action :set_canvase, only: [:show, :edit, :update, :destroy]

  # GET /canvases
  # GET /canvases.json
  def index
    @canvases = Canvas.all
  end

  # GET /canvases/1
  # GET /canvases/1.json
  def show
  end

  # GET /canvases/new
  def new
    @canvase = Canvas.new
  end

  # GET /canvases/1/edit
  def edit
  end

  # POST /canvases
  # POST /canvases.json
  def create
    @canvase = Canvas.new(canvase_params)

    respond_to do |format|
      if @canvase.save
        format.html { redirect_to @canvase, notice: 'Canvas was successfully created.' }
        format.json { render :show, status: :created, location: @canvase }
      else
        format.html { render :new }
        format.json { render json: @canvase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /canvases/1
  # PATCH/PUT /canvases/1.json
  def update
    respond_to do |format|
      if @canvase.update(canvase_params)
        format.html { redirect_to @canvase, notice: 'Canvas was successfully updated.' }
        format.json { render :show, status: :ok, location: @canvase }
      else
        format.html { render :edit }
        format.json { render json: @canvase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /canvases/1
  # DELETE /canvases/1.json
  def destroy
    @canvase.destroy
    respond_to do |format|
      format.html { redirect_to canvases_url, notice: 'Canvas was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_canvase
      @canvase = Canvas.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def canvase_params
      params.require(:canvase).permit(:name, :description)
    end
end

class FontsController < ApplicationController
  
  respond_to :json

  def index
    @fonts = current_user.fonts
  end

  def show
    @font = Font.find(params[:id])
    respond_to do |format|
      format.html
      format.json {
        render json: @font
      }
    end
  end

  def create
    @font = current_user.fonts.create()
    redirect_to @font
  end

  def update
    params[:characters] = params[:characters].to_json
    # raise permitted_params.to_yaml
    respond_with Font.update(params[:id], permitted_params)
  end

  def destroy
    @font = Font.find(params[:id])
    @font.destroy
    redirect_to fonts_path, notice: "Font has been removed."
  end
  
  private
  
  def permitted_params
    params[:font][:characters] = params[:font][:characters].to_json if params[:font][:characters].present?
    params.require(:font).permit(:id, :name, :grid, :x_height, :overshoot, :ascent_height, :line_gap, :characters)
  end
end

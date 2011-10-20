class ExecutionsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    @executions = Execution.scoped.order("updated_at").page(params[:page]).per(10)
    respond_with @executions
  end

  def show
    @execution = Execution.find(params[:id])
    respond_with @execution
  end

  def new
    @execution = Execution.new
    respond_with @execution
  end

  def edit
    @execution = Execution.find(params[:id])
    respond_with @execution
  end

  def create
    @execution = Execution.new(params[:execution])
    @execution.user = current_user
    if @execution.save
      flash[:notice] = "Successfully created execution."
    end
    respond_with @execution
  end

  def update
    @execution = Execution.find(params[:id])
    @execution.user = current_user
    params[:execution].delete(:user_id)
    if @execution.update_attributes(params[:execution])
      flash[:notice] = 'Successfully updated execution.'
    end
    respond_with @execution
  end

  def destroy
    @execution = Execution.find(params[:id])
    @execution.destroy
    flash[:notice] = 'Successfully destroyed execution.'
    respond_with @execution
  end

end

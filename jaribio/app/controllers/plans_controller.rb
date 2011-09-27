class PlansController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    plans = Plan.scoped
    if (params[:q])
      plans = Plan.search(params[:q])
    end
    @plans = plans.order("updated_at").page(params[:page]).per(10)
    respond_with @plans
  end

  def show
    @plan = Plan.find(params[:id])
    respond_with @plan
  end

  def new
    @plan = Plan.new
    respond_with @plan
  end

  def edit
    @plan = Plan.find(params[:id])
    respond_with @plan
  end

  def create
    @plan = Plan.new(params[:plan])
    @plan.user = current_user
    if @plan.save
      flash[:notice] = "Successfully created plan."
    end
    respond_with @plan
  end

  def update
    @plan = Plan.find(params[:id])
    @plan.user = current_user
    params[:plan].delete(:user_id)
    if @plan.update_attributes(params[:plan])
      flash[:notice] = 'Successfully updated plan.'
    end
    respond_with @plan
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    flash[:notice] = 'Successfully destroyed plan.'
    respond_with @plan
  end
end

class PlansController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    plans = Plan.scoped
    if (params[:q])
      plans = Plan.search(params[:q])
    end
    @plans = plans.order("updated_at").page(params[:page]).per(10)
    respond_with @plans
  end

  # GET /plans/open
  def open
    if (params[:id])
      @plan = Plan.find(params[:id])
      @plan.closed_at = nil
      if @plan.save
        flash[:notice] = "Successfully opened plan."
      end
      redirect_to plans_path
      return
    end 

    plans = Plan.open_plans()
    @plans = plans.order("updated_at").page(params[:page]).per(10)
    respond_with @plans
  end

  def show
    @plan = Plan.find(params[:id], :include => [:suites])
    @execution = Execution.new
    @suite = nil
    if (params[:suite_id])
      @suite = Suite.find(params[:suite_id], :include => [:test_cases])
    else
      @suite = @plan.suites.first
    end
    @test_cases = nil
    unless (@suite.nil?)
      if (@plan.closed_at.nil?)
        @test_cases = @suite.test_cases
      else
        @test_cases = @suite.test_cases.where("created_at < ?", @plan.closed_at)
      end
    end
    respond_with @plan
  end

  def new
    @plan = Plan.new
    respond_with @plan
  end

  def edit
    @plan = Plan.find(params[:id])
    suites = @plan.suites.scoped
    if (params[:q])
      suites = Suite.search(params[:q], suites)
    end
    @current_suites = suites.order("name").page(params[:page]).per(10)
    respond_with @plan
  end

  def add_suites
    @plan = Plan.find(params[:id])
    suites = @plan.available_suites
    if (params[:q])
      suites = Suite.search(params[:q], suites)
    end
    @new_suites = suites.order("updated_at").page(params[:page]).per(10)
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

  def associate
    plan = Plan.find(params[:id])
    suite = Suite.find(params[:suite_id])
    plan.suites << suite

    redirect_to add_suites_plan_path(plan)
  end

  def unassociate
    plan = Plan.find(params[:id])
    suite = Suite.find(params[:suite_id])
    plan.suites.delete(suite)

    redirect_to edit_plan_path(plan)
  end

  def close
    @plan = Plan.find(params[:id])
    @plan.closed_at = Time.now
    if @plan.save
      flash[:notice] = "Successfully closed plan."
    end
    redirect_to plans_path
  end

  def copy
    @old_plan = Plan.find(params[:id])
    @plan = @old_plan.deep_clone
    @plan.user = current_user
    if @plan.save
      flash[:notice] = "Successfully copied plan."
    end

    redirect_to edit_plan_path(@plan)
  end
end

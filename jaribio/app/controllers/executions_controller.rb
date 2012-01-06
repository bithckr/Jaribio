class ExecutionsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :js, :html

  def show
    @execution = Execution.find(params[:id])
    respond_with @execution
  end

  def create
    @plan = Plan.find(params[:plan_id])
    @test_case = @plan.test_cases.find(params[:test_case_id])
    @execution = @plan.executions.build(params[:execution])
    @execution.test_case = @test_case
    @execution.user = current_user
    @test_case_counter = params[:test_case_counter]
    if (params[:suite_id])
      @suite = Suite.find(params[:suite_id])
    end
    
    if @execution.save
      flash[:notice] = "Successfully created execution."
    end
    respond_with @execution
  end

end

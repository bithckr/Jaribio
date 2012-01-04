class TestCasesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    cases = TestCase.scoped
    if (params[:q])
      cases = TestCase.search(params[:q])
    end

    @auto_count   = TestCase.count(:conditions => 'automated = 1')
    @manual_count = TestCase.count(:conditions => 'automated = 0')
    @total_count  = @auto_count + @manual_count

    @test_cases = cases.order("updated_at").page(params[:page]).per(10)
    respond_with @test_cases
  end

  def show
    @test_case = TestCase.find(params[:id])
    respond_with @test_case
  end

  def new
    @test_case = TestCase.new
    @suites = Suite.select(:name)
    @pre_steps = PreStep.all()
    respond_with @test_case
  end

  def edit
    @test_case = TestCase.find(params[:id], :include => :suites)
    @suites = Suite.select(:name)
    @pre_steps = PreStep.all()
    respond_with @test_case
  end

  def create
    @test_case = TestCase.new(params[:test_case])
    @test_case.user = current_user

    if params.has_key? :test_case_suites
      @test_case.suite_ids=params[:test_case_suites].split(',')
    end
    if @test_case.save
      flash[:notice] = "Successfully created test case."
      redirect_to edit_test_case_path(@test_case)
    else
      respond_with @test_case
    end
  end

  def update
    @test_case = TestCase.find(params[:id])
    @test_case.user = current_user
    params[:test_case].delete(:user_id)
    if @test_case.update_attributes(params[:test_case])
      flash[:notice] = "Successfully updated test case."
      redirect_to :action => 'index'
    else
      respond_with @test_case
    end
  end

  def destroy
    @test_case = TestCase.find(params[:id])
    @test_case.destroy
    flash[:notice] = "Successfully destroyed test case."
    respond_with @test_case
  end

  def executions
    @test_case = TestCase.find(params[:id])
    @executions = @test_case.executions.order("created_at desc").page(params[:page]).per(10)
    respond_with @test_case
  end

  def sort
    if (defined? params[:moved] and defined? params[:step])
      # moved will look like 'step_3.0', make it '3.0' instead
      params[:moved].gsub!(/.*_(\d+\.\d+)$/, '\1')
      # find the new position for this item
      pos = params[:step].index(params[:moved])
      s_id, s_pos = params[:moved].split('.', 2)
      if (defined? pos and pos != s_pos.to_i)
        step = Step.find(s_id)
        step.sort_order_position = pos
        if step.save
          flash[:notice] = "Successfully saved sort order."
        end
      end
    end
    @test_case = TestCase.find(params[:id])
    respond_with @test_case do |format|
      format.js { render 'sort.js' }
    end
  end
end

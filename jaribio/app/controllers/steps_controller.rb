class StepsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :js, :html

  # GET /steps
  # GET /steps.json
  def index
    @steps = Step.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @steps }
    end
  end

  # GET /steps/1
  # GET /steps/1.json
  def show
    @step = Step.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @step }
    end
  end

  # GET /steps/new
  # GET /steps/new.json
  def new
    @step = Step.new
    @test_case = TestCase.find(params[:test_case_id])
    respond_with @step
  end

  # GET /steps/1/edit
  def edit
    @step = Step.find(params[:id])
    @test_case = TestCase.find(params[:test_case_id])
    @step.test_case_id = @test_case.id
  end

  # POST /steps
  # POST /steps.json
  def create
    @step = Step.new(params[:step])
    @test_case = TestCase.find(params[:test_case_id])
    @step.test_case_id = @test_case.id
    @step.sort_order_position = :last

    if @step.save
      flash[:notice] = "Successfully created step."
    end
    respond_with @step
  end

  # PUT /steps/1
  # PUT /steps/1.json
  def update
    @step = Step.find(params[:id])
    @test_case = TestCase.find(params[:test_case_id])
    @step.test_case_id = @test_case.id

    if @step.update_attributes(params[:step])
        flash[:notice] = 'Step was successfully updated.'
    end
    respond_with @step
  end

  # DELETE /steps/1
  # DELETE /steps/1.json
  def destroy
    @step = Step.find(params[:id])
    @step.destroy
    flash[:notice] = "Successfully destroyed step."

    if(params[:test_case_id])
      @test_case = TestCase.find(params[:test_case_id])
    end
    @step = Step.new
    respond_with @step
  end
end

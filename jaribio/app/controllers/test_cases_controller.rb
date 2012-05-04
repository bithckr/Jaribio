require 'cgi'

class TestCasesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json, :html

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
    if (params[:id].to_s =~ /\A[+-]?\d+\Z/)
      @test_case = TestCase.where(:id => params[:id]).first
    else
      @test_case = TestCase.where(:unique_key => CGI.unescape(params[:id])).first
      if (@test_case.nil?)
        raise ActiveRecord::RecordNotFound.new("Couldn't find TestCase with id=#{params[:id]}")
      end
    end
    if (params[:format] == :json)
      @test_case.includes([:plans]) 
    end
    respond_with @test_case do |format|
      format.html
      format.json { render :json => @test_case, :include => :plans }
    end
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

    TestCase.transaction do 
      if params.has_key? :suites
        update_suites(@test_case, params[:suites])
      end
      if @test_case.save
        flash[:notice] = "Successfully created test case."
        respond_to do |format|
          format.html { redirect_to edit_test_case_path(@test_case) }
          format.json { render :json => @test_case, :status => :created, :location => @test_case }
        end
      else
        respond_with @test_case
      end
    end
  end

  def update
    params[:test_case].delete(:user_id)
    @test_case = TestCase.find(params[:id])

    TestCase.transaction do
      if params.has_key? :suites
        update_suites(@test_case, params[:suites])
      end
      if @test_case.update_attributes(params[:test_case])
        flash[:notice] = "Successfully updated test case."
        redirect_to :action => 'index'
      else
        respond_with @test_case
      end
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
      pos = params[:step].index(params[:moved]) + 1
      s_id, s_pos = params[:moved].split('.', 2)
      if (defined? pos and pos != s_pos.to_i)
        step = Step.find(s_id)
        if step.insert_at(pos) != false
          flash[:notice] = "Successfully saved sort order."
        end
      end
    end
    @test_case = TestCase.find(params[:id])
    respond_with @test_case do |format|
      format.js { render 'sort.js' }
    end
  end

  def copy
    @old_case = TestCase.find(params[:id])
    @test_case = @old_case.deep_clone
    @test_case.user = current_user
    if @test_case.save
      flash[:notice] = "Successfully copied test case."
    end

    redirect_to edit_test_case_path(@test_case)
  end

  private

  def update_suites(test_case, suite_names)
    suite_ids = []
    suite_names.split(',').each do |suite_name|
      suite = Suite.find_or_initialize_by_name(suite_name)
      if (suite.new_record?)
        suite.user = current_user
        suite.save!
      end
      suite_ids << suite.id
    end
    test_case.suite_ids=suite_ids
  end

end

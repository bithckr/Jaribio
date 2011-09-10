class TestCasesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    cases = TestCase.scoped
    if (params[:q])
      cases = TestCase.search(params[:q])
    end
    @test_cases = cases.order("updated_at").page(params[:page]).per(10)
    respond_with @test_cases
  end

  def show
    @test_case = TestCase.find(params[:id])
    respond_with @test_case
  end

  def new
    @test_case = TestCase.new
    respond_with @test_case
  end

  def edit
    @test_case = TestCase.find(params[:id])
    respond_with @test_case
  end

  def create
    @test_case = TestCase.new(params[:test_case])
    @test_case.user = current_user
    if @test_case.save
      flash[:notice] = "Successfully created test case."
    end
    respond_with @test_case
  end

  def update
    @test_case = TestCase.find(params[:id])
    @test_case.user = current_user
    params[:test_case].delete(:user_id)
    if @test_case.update_attributes(params[:test_case])
      flash[:notice] = "Successfully updated test case."
    end
    respond_with @test_case
  end

  def destroy
    @test_case = TestCase.find(params[:id])
    @test_case.destroy
    flash[:notice] = "Successfully destroyed test case."
    respond_with @test_case
  end
end

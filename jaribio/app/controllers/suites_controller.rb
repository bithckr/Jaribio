class SuitesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def index
    suites = Suite.scoped
    if (params[:q])
      suites = Suite.search(params[:q])
    end
    @suites = suites.order("updated_at").page(params[:page]).per(10)
    respond_with @suites
  end

  def show
    @suite = Suite.find(params[:id])
    respond_with @suite
  end

  def new
    @suite = Suite.new
    respond_with @suite
  end

  def edit
    @suite = Suite.find(params[:id])
    cases = @suite.available_test_cases
    @new_cases = cases.order("updated_at").page(params[:npage]).per(10)
    @current_test_cases = @suite.test_cases
    @current_test_cases = Kaminari.paginate_array(@current_test_cases).page(params[:cpage]).per(10)
    respond_with @suite
  end

  def create
    @suite = Suite.new(params[:suite])
    @suite.user = current_user
    if @suite.save
      flash[:notice] = "Successfully created suite."
    end
    respond_with @suite
  end

  def update
    @suite = Suite.find(params[:id])
    @suite.user = current_user
    params[:suite].delete(:user_id)
    if @suite.update_attributes(params[:suite])
      flash[:notice] = 'Successfully updated suite.'
    end
    respond_with @suite
  end

  def destroy
    @suite = Suite.find(params[:id])
    @suite.destroy
    flash[:notice] = 'Successfully destroyed suite.'
    respond_with @suite
  end
  
  def unassociate
    suite = Suite.find(params[:id])
    test_case = TestCase.find(params[:test_case_id])
    suite.test_cases.delete(test_case) 

    redirect_to edit_suite_path(suite)
  end
end

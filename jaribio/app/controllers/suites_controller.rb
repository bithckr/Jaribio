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

  def new
    @suite = Suite.new
    respond_with @suite
  end

  def edit
    @suite = Suite.find(params[:id])
    @current_cases = @suite.test_cases
    respond_with @suite
  end

  def add_cases
    @suite = Suite.find(params[:id])
    cases = @suite.available_test_cases
    if (params[:q])
      cases = TestCase.search(params[:q], cases)
    end
    @new_cases = cases.order("updated_at").page(params[:page]).per(10)
    respond_with @suite
  end

  def create
    @suite = Suite.new(params[:suite])
    @suite.user = current_user
    if @suite.save
      flash[:notice] = "Successfully created suite."
      redirect_to :action => 'index'
    else
      respond_with @suite
    end
  end

  def update
    @suite = Suite.find(params[:id])
    @suite.user = current_user
    params[:suite].delete(:user_id)
    if @suite.update_attributes(params[:suite])
      flash[:notice] = 'Successfully updated suite.'
      redirect_to :action => 'index'
    else
      respond_with @suite
    end
  end

  # 
  # Should really only need deal with the one we're moving, but here we end
  # up saving a lot more stuff.
  #
  def sort
    if (defined? params[:moved] and defined? params[:test_case])
      # moved will look like 'test_case_3.0', make it '3.0' instead
      params[:moved].gsub!(/.*_(\d+\.\d+)$/, '\1')
      # find the new position for this item
      pos = params[:test_case].index(params[:moved]) + 1
      tc_id, tc_pos = params[:moved].split('.', 2)
      if (defined? pos and pos != tc_pos.to_i)
        stc = SuiteTestCase.where(:suite_id => params[:id], :test_case_id => tc_id).first
        if stc.insert_at(pos) != false
          flash[:notice] = "Successfully saved sort order."
        end
      end
    end
    @suite = Suite.find(params[:id])
    # must redraw list with updated id #'s
    @current_cases = @suite.test_cases
    respond_with @suite do |format|
      format.js { render 'sort.js' }
    end
  end

  def destroy
    @suite = Suite.find(params[:id])
    @suite.destroy
    flash[:notice] = 'Successfully destroyed suite.'
    respond_with @suite
  end

  def associate
    suite = Suite.find(params[:id])
    test_case = TestCase.find(params[:case_id])
    suite.test_cases << test_case

    redirect_to add_cases_suite_path(suite)
  end

  def unassociate
    suite = Suite.find(params[:id])
    test_case = TestCase.find(params[:case_id])
    suite.test_cases.delete(test_case) 

    redirect_to edit_suite_path(suite)
  end
end

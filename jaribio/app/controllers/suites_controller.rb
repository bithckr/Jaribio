class SuitesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  # GET /suites
  # GET /suites.xml
  def index
    @suites = Suite.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @suites }
    end
  end

  # GET /suites/1
  # GET /suites/1.xml
  def show
    @suite = Suite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @suite }
    end
  end

  # GET /suites/new
  # GET /suites/new.xml
  def new
    @suite = Suite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @suite }
    end
  end

  # GET /suites/1/edit
  def edit
    @suite = Suite.find(params[:id])
  end

  # POST /suites
  # POST /suites.xml
  def create
    @suite = Suite.new(params[:suite])
    @suite.user = current_user

    respond_to do |format|
      if @suite.save
        format.html { redirect_to(@suite, :notice => 'Suite was successfully created.') }
        format.xml  { render :xml => @suite, :status => :created, :location => @suite }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @suite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /suites/1
  # PUT /suites/1.xml
  def update
    @suite = Suite.find(params[:id])
    @suite.user = current_user

    respond_to do |format|
      if @suite.update_attributes(params[:suite])
        format.html { redirect_to(@suite, :notice => 'Suite was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @suite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /suites/1
  # DELETE /suites/1.xml
  def destroy
    @suite = Suite.find(params[:id])
    @suite.destroy

    respond_to do |format|
      format.html { redirect_to(suites_url) }
      format.xml  { head :ok }
    end
  end
end

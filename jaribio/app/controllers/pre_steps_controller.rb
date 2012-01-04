class PreStepsController < ApplicationController
  # GET /pre_steps
  # GET /pre_steps.json
  def index
    @pre_steps = PreStep.order("name").page(params[:page]).per(10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pre_steps }
    end
  end

  # GET /pre_steps/1
  # GET /pre_steps/1.json
  def show
    @pre_step = PreStep.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pre_step }
    end
  end

  # GET /pre_steps/new
  # GET /pre_steps/new.json
  def new
    @pre_step = PreStep.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pre_step }
    end
  end

  # GET /pre_steps/1/edit
  def edit
    @pre_step = PreStep.find(params[:id])
  end

  # POST /pre_steps
  # POST /pre_steps.json
  def create
    @pre_step = PreStep.new(params[:pre_step])

    respond_to do |format|
      if @pre_step.save
        format.html { redirect_to @pre_step, notice: 'Pre step was successfully created.' }
        format.json { render json: @pre_step, status: :created, location: @pre_step }
      else
        format.html { render action: "new" }
        format.json { render json: @pre_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pre_steps/1
  # PUT /pre_steps/1.json
  def update
    @pre_step = PreStep.find(params[:id])

    respond_to do |format|
      if @pre_step.update_attributes(params[:pre_step])
        format.html { redirect_to @pre_step, notice: 'Pre step was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @pre_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pre_steps/1
  # DELETE /pre_steps/1.json
  def destroy
    @pre_step = PreStep.find(params[:id])
    @pre_step.destroy

    respond_to do |format|
      format.html { redirect_to pre_steps_url }
      format.json { head :ok }
    end
  end
end

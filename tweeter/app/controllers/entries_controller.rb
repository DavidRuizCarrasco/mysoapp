class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :edit, :update, :destroy]

  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.all
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
  end

  # GET /entries/new
  def new
    if !session[:user]
      redirect_to entries_path, :alert => "You have to log in to create a new tweet "
    else
        @entry = Entry.new
end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
    if @entry.user.name != session[:user]
      redirect_to entries_path, :alert => "You cannot edit another user’s tweet!"
    else
      @entry = Entry.find(params[:id])
    end
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entry.new(entry_params)
    @entry.user = User.find_by name: session[:user]

    respond_to do |format|
      if @entry.save
        format.html { redirect_to entries_url, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entries/1
  # PATCH/PUT /entries/1.json
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to entries_path, notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    if @tweet.user != session[:user]
      redirect_to entries_url, :alert => "You cannot delete another user’s tweet!"
    else
    respond_to do |format|
      format.html { redirect_to entries_url, notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:text, :user_id, :likes)
    end
  end
end

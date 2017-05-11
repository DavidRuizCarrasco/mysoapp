class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :edit, :update, :destroy, :like, :unlike, :share]

  # GET /entries
  # GET /entries.json
  def index
    if session[:user] != nil
      if (User.where(name: session[:user]).first).role != 0 
        friends = Array.new
        friendships = Relation.where(user1_id: User.where(name: session[:user]).first , status: 1)
        if friendships != nil
          for friendship in friendships
            friends.push(friendship.user2_id)
          end
        end
        friends.push((User.where(name: session[:user]).first).id)
        @entries = Entry.where('user_id IN (?)',friends)
      else
        @entries = Entry.all
      end
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
  end

  # GET /entries/new
  def new
    if !session[:user]
      redirect_to entries_path, :alert => "You have to log in to create a new entry"
    else
        @entry = Entry.new
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
    if @entry.user.name != session[:user] or @entry.user.role != 0
      redirect_to entries_path, :alert => "You cannot edit another user entry!"
    else
      @entry = Entry.find(params[:id])
    end
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entry.new(entry_params)
    @entry.user = User.find_by name: session[:user]
    @entry.likes = 0

    respond_to do |format|
      if @entry.save
        format.html { redirect_to entries_url, notice: 'Entry was successfully created.' }
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
    if @entry.user.name != session[:user] or @entry.user.role != 0
      redirect_to entries_url, :alert => "You cannot delete another user Entry!"
    else
      @entry.destroy
      respond_to do |format|
        format.html { redirect_to entries_url, notice: 'Entry was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  def share
    text = @entry.user.name + ": " + @entry.text 
    @entryShared = Entry.create(user: User.where(name: session[:user]).first, text: text, likes: 0)

    respond_to do |format|
      if @entryShared.save
        format.html { redirect_to entries_url, notice: 'Entry was successfully shared.' }
        format.json { render :show, status: :created, location: @entryShared }
      else
        format.html { render :new }
        format.json { render json: @entryShared.errors, status: :unprocessable_entity }
      end
    end
  end

  def like
    @entry.likes = @entry.likes + 1
    if @entry.save
        redirect_to entries_url, notice: 'Like registered' 
    else
      render :new         
    end
  end 

  def unlike
    if @entry.likes > 0 
      @entry.likes = @entry.likes - 1
      if @entry.save
        redirect_to entries_url, notice: 'Unlike registered' 
      else
        render :new         
    end
    else
      redirect_to entries_url, notice: 'You can not unlike a 0 like entry' 
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


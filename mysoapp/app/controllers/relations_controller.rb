class RelationsController < ApplicationController
  before_action :set_relation, only: [:show, :edit, :update, :destroy, :accept, :deny]

  # GET /relations
  # GET /relations.json
  def index
    if session[:user] != nil
      if (User.where(name: session[:user]).first).role != 0 
        me = User.where(name: session[:user]).first
        @relations = Relation.where('user1_id = ? OR user2_id = ?', me, me)
      else
        @relations = Relation.all
      end
    end
  end

  # GET /relations/1
  # GET /relations/1.json
  def show
  end

  # GET /relations/new
  def new
    if !session[:user]
      redirect_to relations_path, :alert => "You have to log in to create a new entry "
    else
        @relation = Relation.new
    end
  end

  # GET /relations/1/edit
  def edit
    @relation = relation.find(params[:id])
    if @relation.user1_id.name != @currentUser.name or @currentUser.role != 0
      redirect_to entries_path, :alert => "You cannot edit another user’s relations!"
    else
      @relation = Relation.find(params[:id])
    end
  end

  # POST /relations
  # POST /relations.json
  def create
    @relation = Relation.new(relation_params)
    name1 = @relation.user1_id
    name2 = @relation.user2_id
    user1 = User.where(name: name1).first
    user2 = User.where(name: name2).first
    @relation = Relation.create(user1_id: user1.id, user2_id: user2.id, status: 0)
    
    respond_to do |format|
      if @relation.save
        format.html { redirect_to @relation, notice: 'Relation was successfully created.' }
        format.json { render :show, status: :created, location: @relation }
      else
        format.html { render :new }
        format.json { render json: @relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /relations/1
  # PATCH/PUT /relations/1.json
  def update
    respond_to do |format|
      if @relation.update(relation_params)
        format.html { redirect_to @relation, notice: 'Relation was successfully updated.' }
        format.json { render :show, status: :ok, location: @relation }
      else
        format.html { render :edit }
        format.json { render json: @relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relations/1
  # DELETE /relations/1.json
  def destroy
    if @relation.user1_id == @currentUser.id or @currentUser.role == 0
      @relation.destroy
      respond_to do |format|
        format.html { redirect_to relations_url, notice: 'Relation was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to relations_url, notice: 'You cant revoke anothers users queries'
    end
  end
  

  def query
    @relation = Relation.create(user1_id: (User.where(name: session[:user]).first).id, user2_id: params[:id], status: 0)
   
    respond_to do |format|
      if @relation.save
        format.html { redirect_to relations_url, notice: 'Query sent' }
        format.json { render :show, status: :created, location: @relation }
      else
        format.html { render :new }
        format.json { render json: @relation.errors, status: :unprocessable_entity }
      end
    end
  end

  def accept

    if @relation.user2_id == @currentUser.id or @currentUser.role == 0
      if @relation.status == 0
        @relation.status = 1
        if @relation.save
          redirect_to relations_url, notice: 'Relation acepted' 
        else
          render :new         
        end
      else
        redirect_to relations_url, notice: 'Relation already acepted'
      end
    else
      redirect_to relations_url, notice: 'You cant accept this relation'
    end
  end 

  def deny
    if @relation.user2_id == @currentUser.id or @currentUser.role == 0
      if @relation.status == 0
        @relation.destroy
        respond_to do |format|
          format.html { redirect_to relations_url, notice: 'Relation was denied.' }
          format.json { head :no_content }
        end
      else
        redirect_to relations_url, notice: 'Relation already acepted'
      end
    else
      redirect_to relations_url, notice: 'You cant deny this relation'
    end
  end 


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relation
      @relation = Relation.find(params[:id])
      @currentUser = User.where(name: session[:user]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relation_params
      params.require(:relation).permit(:user1_id, :user2_id, :status)
    end
end

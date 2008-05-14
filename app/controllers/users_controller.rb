class UsersController < ApplicationController
  
  before_filter :login_required
  before_filter :only_admin, :only => :index
  before_filter :fetch_user, :only =>   [:edit, :update]
  

  # def create
  #   cookies.delete :auth_token
  #   # protects against session fixation attacks, wreaks havoc with 
  #   # request forgery protection.
  #   # uncomment at your own risk
  #   # reset_session
  #   @user = User.new(params[:user])
  #   @user.save
  #   if @user.errors.empty?
  #     self.current_user = @user
  #     redirect_back_or_default('/')
  #     flash[:notice] = "Thanks for signing up!"
  #   else
  #     render :action => 'new'
  #   end
  # end
  
  def edit; end
  
  def update
    
    respond_to do |format| 
      @user.attributes = params[:user]
      @user.role = params[:user][:role] if current_user.admin?
      @user.active = params[:user][:active] if current_user.editor?
      if @user.save
        flash[:notice] = "Perfil atualizado com sucesso."
        format.html { redirect_to posts_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def index
    @users = User.find(:all, :order => "id ASC")
  end
  
  protected

  def fetch_user
    if current_user.editor? && params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end


end

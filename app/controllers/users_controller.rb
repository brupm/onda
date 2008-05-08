class UsersController < ApplicationController
  
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
      @user.admin = params[:user][:admin] if current_user.admin?
      puts "ADMIN #{params[:user][:admin]}"
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
  
  protected

  def fetch_user
    if current_user.admin? && params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end
  
  

end

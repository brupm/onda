# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  def new
  end

  def create
    #if using_open_id?
      open_id_authentication(params[:openid_url])
    #else
    #  password_authentication(params[:login], params[:password])
    #end
  end
  
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Volte sempre!"
    redirect_back_or_default('/')
  end
 
   protected

   def open_id_authentication(openid_url)
     authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, identity_url, registration|
       if result.successful?
         @user = User.find_or_initialize_by_identity_url(identity_url)
         if @user.new_record?
           @user.nick = registration['nickname']
           @user.email = registration['email']
           @user.save(false)
         end
         self.current_user = @user
         successful_login
       else
         failed_login result.message
       end
     end
   end

   def password_authentication(login, password)
     self.current_user = User.authenticate(login, password)
     if logged_in?
       successful_login
     else
       failed_login
     end
   end

   def failed_login(message = "Falha na autenticação.")
     flash.now[:error] = message
     render :action => 'new'
   end

   def successful_login
     if params[:remember_me] == "1"
       self.current_user.remember_me
       cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
     end
     redirect_back_or_default('/')
     flash[:notice] = "Funcionou! Você foi identificado."
   end
end

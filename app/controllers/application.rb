class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery # :secret => '20f1f495d10868e7b22140c5a4f11a4d'
  include AuthenticatedSystem
  
  def only_admin
    (logged_in? && current_user.admin?) || protected_access_denied
  end
  
  def only_editor
    (logged_in? && current_user.editor?) || protected_access_denied
  end
  
  def protected_access_denied
    respond_to do |format|
      format.html do
        flash[:notice] = "Você não tem permissão para completar esta ação."
        redirect_to root_url
      end
      format.any do
        request_http_basic_authentication 'Admin Password'
      end
    end
  end
end

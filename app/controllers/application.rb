class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery # :secret => '20f1f495d10868e7b22140c5a4f11a4d'
  include AuthenticatedSystem
end

class WidgetController < ApplicationController
  def index
  end
  
  def embedded
		@posts = Post.find :all, :limit => 5, :order => 'created_at'
		render :layout => false
  end

end

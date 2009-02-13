class WidgetController < ApplicationController
  def index
  end
  
  def embedded
		@posts = Post.last 5
		render :layout => false
  end
  
  def ruby_inside
    @posts = Post.last(10)
    render :layout => false
  end

end

class BloggersController < ApplicationController
  def index
    @bloggers = User.find(:all, :joins => :posts, :conditions => ("blogger is true"))
  end
end

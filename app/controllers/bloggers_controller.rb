class BloggersController < ApplicationController
  def index
    @bloggers = User.find(:all, :conditions => ("blogger is true"), :order => "created_at ASC")
  end
end
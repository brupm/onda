class BloggersController < ApplicationController
  def index
    @bloggers = User.find(:all, {
      :select => "count(*) as posts_count, users.*", 
      :group => "user_id", 
      :joins => "inner join posts on posts.user_id = users.id", 
      :conditions => ("blogger is true"),
      :order => "1 desc"
    })
  end
end

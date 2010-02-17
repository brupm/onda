class BloggersController < ApplicationController
  def index
    @bloggers = User.find(:all, {
      :select => "count(posts.id), users.*", 
      :group => "email", 
      :joins => "left outer join posts on posts.user_id = users.id", 
      :conditions => "blogger is true",
      :order => "1 desc"
    })
  end
end

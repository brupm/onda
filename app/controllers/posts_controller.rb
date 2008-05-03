class PostsController < ApplicationController

  before_filter :fetch_post, :only =>   [:edit, :update, :destroy]
  #before_filter :authorize,  :except => [:index, :new, :create]
  before_filter :login_required, :only => [ :new, :update ]
  
  def index
    @posts = Post.latest(:limit => 20)
  end
  
  def new
    @post = Post.new
    respond_to do |format|
      format.html 
      format.xml { render :xml => @post }
    end    
  end
  
  def create
    @post = Post.create(params[:post])
    @post.user = current_user
    respond_to do |format| 
      if @post.save
        flash[:notice] = "Post was successfully created."
        format.html { redirect_to posts_path }
        format.xml  { render :xml => @post, :status => :create }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format| 
      if @post.save
        flash[:notice] = "Post was successfully created."
        format.html { redirect_to posts_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    if @post.destroy
      flash[:notice] = "Post was successfully deleted"
      respond_to do |format|
        format.html { redirect_to posts_path }
        format.xml  { head :ok }
      end
    end
  end

  protected

  def fetch_post
    @post = Post.find(params[:id])
  end
  
  def authorize
    authenticate_or_request_with_http_basic do |username, password|
      username == "bopia" && password == "bopia"
    end
  end
  
end

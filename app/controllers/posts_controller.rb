class PostsController < ApplicationController

  before_filter :fetch_post, :only =>   [:edit, :update, :destroy]
  before_filter :login_required, :only => [ :new, :update ]
  
  def index    
    respond_to do |format|
      format.rss  { @posts = Post.find_latest(:limit => 20) }
      format.html { @posts = Post.paginate_latest(:page => params[:page] , :per_page => 50) }
    end
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
    @post.user_id = current_user.id
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
end

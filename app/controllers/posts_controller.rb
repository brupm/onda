class PostsController < ApplicationController

  before_filter :fetch_post, :only =>   [:edit, :update, :destroy, :publish, :refuse, :show]
  before_filter :login_required, :only => [ :new, :update, :pending, :publish, :refuse ]
  
  def index    
    respond_to do |format|
      format.rss  { @posts = Post.find_latest(:limit => 50) } 
      # , :conditions => ["published_at < ?", 30.minutes.ago])
      # timezones was not allowing the posts to show up at all.
      format.html { @posts = Post.paginate_latest(:page => params[:page], :per_page => 30) }
    end
  end
  
  def my
    @posts = Post.paginate(:page => params[:page], :conditions => {:user_id => current_user.id}, :order => 'created_at DESC')
    @title = "Meus artigos"
    @show_state = true
    render :action => :index
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
        if current_user.admin? || current_user.has_min_authorized_posts?
          flash[:notice] = "Artigo criado como sucesso."
        else
          flash[:notice] = "Artigo criado como sucesso. <br />Seu artigo está em moderação por não ter pelo menos 10 artigos publicados."
        end
        format.html { redirect_to my_posts_path }
        format.xml  { render :xml => @post, :status => :create }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def pending
    @posts = Post.paginate_pending :page => params[:page]
    @title = "Artigos pendentes"
    render :action => :index
  end
  
  def publish
    @post.authorized_by_id = current_user.id
    
    respond_to do |format|
      if @post.save
        flash[:notice] = "Publicado com sucesso."
        format.html { redirect_to pending_posts_path }
      else
        flash[:notice] = "Problemas na publicação."
        format.html { redirect_to pending_posts_path }
      end
    end
  end
  
  def refuse
    @post.refused_by_id = current_user.id
    @post.refused_text = params[:post][:refused_text]
    
    respond_to do |format|
      if @post.save
        flash[:notice] = "Rejeitado com sucesso."
        format.html { redirect_to pending_posts_path }
      else
        flash[:notice] = "Erro ao rejeitar."
        format.html { redirect_to pending_posts_path }
      end
    end
  end
  
  def edit; end
  
  def update
    respond_to do |format| 
      if @post.update_attributes(params[:post])
        flash[:notice] = "Artigo atualizado com sucesso."
        format.html { redirect_to posts_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show; end
  
  def destroy
    if @post.destroy
      flash[:notice] = "Artigo apagado com sucesso."
      respond_to do |format|
        format.html { redirect_to posts_path }
        format.xml  { head :ok }
      end
    end
  end

  protected

  def fetch_post
    @post = Post.find_by_permalink(params[:id])
  end
end

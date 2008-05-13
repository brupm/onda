class PostsController < ApplicationController

  before_filter :fetch_post, :only =>   [:edit, :update, :destroy, :publish, :refuse, :show]
  before_filter :login_required, :only => [ :new, :update, :pending, :edit, :update, :destroy, :publish, :refuse ]
  before_filter :only_editor, :only => [ :publish, :refuse, :pending ]
  before_filter :only_admin, :only => [ :unpublish ]
  before_filter :tag_cloud, :only => [:index, :my, :search, :pending]
  
  def index    
    respond_to do |format|
      format.rss  { @posts =  Post.find_latest(:limit => 50, :conditions => ["published_at < DATE_SUB(?, INTERVAL 15 MINUTE)", Time.now.utc]) } 
      format.html { @posts = Post.paginate_latest(:page => params[:page], :per_page => 30) }
    end
  end
  
  def my
    @posts = Post.paginate(:page => params[:page], :conditions => {:user_id => current_user.id}, :order => 'created_at DESC')    
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
        if current_user.editor? || current_user.has_min_authorized_posts?
          flash[:notice] = "Artigo criado como sucesso."
        else
          flash[:notice] = "Artigo criado como sucesso. <br />Seu artigo será avaliado. Após 10 artigos autorizados seus artigos serão ."
        end
        begin
          Notifier.deliver_new_post(@post) if Env.production?
        rescue
          logger.warn { "could not send email" }
        ensure
          format.html { redirect_to my_posts_path }
          format.xml  { render :xml => @post, :status => :create }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def pending
    @posts = Post.paginate_pending :page => params[:page]
  end
  
  def publish
    @post.authorized_by_id = current_user.id
    
    respond_to do |format|
      if @post.save
        flash[:notice] = "Publicado com sucesso."
        format.html { redirect_to posts_path }
      else
        flash[:notice] = "Problemas na publicação."
        format.html { redirect_to pending_posts_path }
      end
    end
  end
  
  def unpublish
    @post.authorized_by_id = nil
    @post.refused_text = "Este artigo foi retirado por algum administrador."
    refuse
  end
  
  def refuse
    @post.refused_by_id = current_user.id
    @post.refused_text ||= params[:post][:refused_text]
    
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
  
  def edit
    unless @post.can_edit?(current_user)
      flash[:notice] = "Este artigo não pode ser editar por você, entre em contato com algum administrador."
      redirect_to posts_url
    end
  end
  
  def update
    respond_to do |format| 
      if @post.update_attributes(params[:post])
        flash[:notice] = "Artigo atualizado com sucesso."
        format.html { redirect_to post_path(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show; end
  
  def search
    @posts = Post.find_tagged_with(params[:id])
  end

  def tag_cloud
    if Post.tag_counts.size > 50      
      @tags = Post.tag_counts(:order => "tags.name", :at_least => (Post.tag_counts.size/25).to_i) rescue 0
    else 
      @tags = Post.tag_counts
    end
  end

  protected

  def fetch_post
    @post = Post.find_by_permalink(params[:id])
  end
end

class PostsController < ApplicationController

  before_filter :fetch_post, :only =>   [:edit, :update, :destroy, :publish, :refuse]
  before_filter :login_required, :only => [ :new, :update, :pending, :edit, :update, :destroy, :publish, :refuse, :my, :all, :create ]
  before_filter :only_admin, :only => [ :publish, :refuse, :pending, :all ]
  before_filter :tag_cloud, :only => [:index, :my, :search, :pending]
  
  def index    
    respond_to do |format|
      format.html { @posts = Post.paginate_latest(:page => params[:page], :per_page => 30) }
      format.rss  { @posts = Post.find_latest(:limit => 50, :conditions => ["published_at < DATE_SUB(?, INTERVAL 15 MINUTE)", Time.now.utc]) } 
    end
  end
  
  def all
    respond_to do |format|
      @posts = Post.paginate(:page => params[:page], :per_page => 30, :order => 'created_at DESC')
      format.html
    end
  end
  
  def my
    @posts = Post.paginate(:page => params[:page], :conditions => {:user_id => current_user.id}, :order => 'created_at DESC')    
  end
  
  #bookmarklet: javascript:location.href='http://rubyonda.com/artigos/novo?title='+encodeURIComponent(document.title)+'&url='+encodeURIComponent(location.href)
  def new
    params[:title] = params[:title].strip unless params[:title].blank?
    @post = Post.new(:title => params[:title], :url => params[:url]) #params <- bookmarklet
    respond_to do |format|
      format.html 
      format.xml { render :xml => @post }
    end
  end
  
  def create
    @post = Post.create(params[:post])
    @post.user_id = current_user.id
    @user = @post.user
    respond_to do |format| 
      if @post.save
        if current_user.editor? || current_user.has_min_authorized_posts?
          flash[:notice] = "Artigo criado como sucesso. <br/> Em 10 minutos será publicado no RSS e no Twitter, aproveite para revisar o conteúdo."
        else
          flash[:notice] = "Artigo criado como sucesso. <br />Seu artigo agora será avaliado.<br/> Após 10 artigos autorizados seus artigos serão automaticamente publicados. <br/>Enquanto seu artigo não foi publicado, aproveite para revisá-lo."
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
  
  def destroy
    unless @post.can_destroy?(current_user)
      flash[:notice] = "Este artigo não pode ser apagado por você, entre em contato com algum administrador."
      redirect_to posts_path
      return
    end
    
    @post.authorized_by_id = nil
    @post.refused_by_id = current_user.id
    @post.refused_text = ((current_user == @post.user) ? "Este artigo foi removido pelo próprio autor" : "Este artigo foi apagado por algum administrador.")
    
    respond_to do |format|
      if @post.save
        flash[:notice] = "Apagado com sucesso."
        format.html { redirect_to pending_posts_path }
      else
        flash[:notice] = "Erro ao apagar."
        format.html { redirect_to pending_posts_path }
      end
    end
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
      flash[:notice] = "Este artigo não pode ser editado por você, entre em contato com algum administrador."
      redirect_to posts_path
    end
  end
  
  def update
    unless @post.can_edit?(current_user)
      flash[:notice] = "Este artigo não pode ser editado por você, entre em contato com algum administrador."
      redirect_to posts_path
      return
    end
    respond_to do |format| 
      if @post.update_attributes(params[:post])
        flash[:notice] = "Artigo atualizado com sucesso."
        format.html do
          if @post.published?
            redirect_to post_path(@post)
          elsif !current_user.editor?
            redirect_to my_posts_path
          else
            redirect_to posts_path
          end
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @post = Post.find_by_permalink(params[:id], :conditions => {:state => "published"})
  end
  
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

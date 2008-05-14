# == Schema Information
# Schema version: 20080510134432
#
# Table name: posts
#
#  id               :integer(11)     not null, primary key
#  title            :string(255)     not null
#  url              :string(255)     not null
#  description      :text            not null
#  user_id          :integer(11)     not null
#  state            :string(255)     default("pending"), not null
#  created_at       :datetime
#  updated_at       :datetime
#  published_at     :datetime
#  authorized_by_id :integer(11)
#  refused_by_id    :integer(11)
#  refused_text     :string(200)
#  permalink        :string(255)
#  cached_tag_list  :string(255)
#  tweeted_at       :datetime
#

class Post < ActiveRecord::Base
  
  acts_as_taggable
  set_cached_tag_list_column_name "cached_tag_list"
  
  STATE_PT = {'pending' => "pendente", 'refused' => "rejeitado", 'published' => "publicado"}
  
  attr_accessor :hidden
  
  belongs_to :user
  belongs_to :authorized_by, :class_name => "User", :foreign_key => :authorized_by_id

  attr_accessible :title, :description, :url, :cached_tag_list, :hidden, :tag_list
  attr_human_name :title => 'Título', :description => 'Texto', :url => "Link"
  
  validates_presence_of :user_id, :url, :title, :description
  validates_length_of :description, :within => 10..290
  validates_length_of :title, :within => 10..70
  validates_uniqueness_of :title
  
  validates_presence_of :refused_text, :if => :refused?
  
  before_validation_on_create :set_initial_state
  before_validation_on_update :set_state
  
  before_save :set_permalink
  
  def validate
    if !hidden.nil?  
      if hidden.length > 0
        errors.add("spam bot detectado, seu post ")
      end
    end
  end
  
  def posted_at
    published_at || created_at
  end
  
  def pending?
    state == 'pending'
  end
  
  def refused?
    state == 'refused'
  end
  
  def published?
    state == 'published'
  end
  
  def state_pt
    STATE_PT[state]
  end
  
  def full_url
    unless url.nil?
      url.include?("http://") ? url : "http://#{url}" 
    end
  end
  
  def self.find_latest(query_options = {})
    with_scope(:find => {:conditions => {:state => 'published'}, :order => 'published_at DESC'} ) do
      find(:all, query_options)
    end
  end
  
  def self.find_pending(query_options = {})
    with_scope(:find => {:conditions => {:state => 'pending'}, :order => 'created_at'} ) do
      find(:all, query_options)
    end
  end
  
  def self.pending_count
    count(:conditions => {:state => 'pending'})
  end
  
  def can_edit?(user)
    can_handle?(user)
  end
  
  def can_destroy?(user)
    can_handle?(user)
  end
  
  if OVERLOAD_TO_PARAM == "yes" 
    def to_param
      self.permalink
    end
  end
  
  def set_permalink
    self.permalink = self.title.downcase.gsub(" ", "-").gsub(".", "").remover_acentos
  end
  
  private
  
  def can_handle?(user)
    case user.role
    when 'admin'
      return true
    when 'editor'
      return self.pending? || (self.published? && published_at.to_time > 30.minutes.ago)
    when 'writer'
      return self.user_id == user.id && (self.pending? || (self.published? && user.has_min_authorized_posts? && published_at.to_time > 10.minutes.ago))
    end
    false    
  end
  
  def set_initial_state
    if user_id && (self.user.editor? || user.has_min_authorized_posts?)
      self.state = 'published'
      self.published_at = Time.zone.now
    end
  end
  
  def set_state
      if !refused_by_id.blank? && state != 'refused'
        self.state = 'refused'
        self.authorized_by_id = nil
      elsif state == 'pending' && !authorized_by_id.blank?
        self.state = 'published'
        self.published_at = Time.zone.now
      end
  end

  
end


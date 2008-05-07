# == Schema Information
# Schema version: 20080504223159
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
#

class Post < ActiveRecord::Base
  
  STATE_PT = {'pending' => "pendente", 'refused' => "rejeitado", 'published' => "publicado"}
  
  belongs_to :user
  belongs_to :authorized_by, :class_name => "User", :foreign_key => :authorized_by_id
  
  attr_protected :state, :authorized_by_id, :user_id, :published_at, :refused_by_id, :refused_text
  attr_human_name :title => 'Título', :description => 'Texto', :url => "Link"
  
  validates_presence_of :user_id, :url, :title, :description
  validates_length_of :description, :maximum => 290
  
  validates_presence_of :refused_text, :if => :refused?
  
  before_validation :set_state
  
  def posted_at
    published_at || created_at
  end
  
  def pending?
    state == 'pending'
  end
  
  def refused?
    state == 'refused'
  end
  
  def state_pt
    STATE_PT[state]
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
  
  
  private
  
  def set_state
    if user_id       
      if state.blank?
        if self.user.admin? || user.has_min_authorized_posts?
          self.state = 'published'
          self.published_at = Time.now
        else
          self.state = 'pending'
        end
      elsif !refused_by_id.blank? && state != 'refused'
        self.state = 'refused'
      elsif state == 'pending' && !authorized_by_id.blank?
        self.state = 'published'
        self.published_at = Time.now
      end
    end
  end
  
  
  
end


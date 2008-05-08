# script/runner -e production "require 'tweet_posts'; TweetPosts.execute" 

require 'twitter'

class TweetPosts

  def self.execute
    twit = Twitter::Base.new(ENV['TWITTER_USER'], ENV['TWITTER_PASS'])

    Post.find_latest(:limit => 50, :order => "published_at", :conditions => ["published_at < DATE_SUB(?, INTERVAL 5 MINUTE) AND tweeted_at IS NULL", Time.now.utc]).each do |post|
      max_size = 140 - post.full_url.chars.length - 1 #(space)
      max_size_truncate = max_size - "...".chars.length
      title = post.title.strip
      title = (title.chars.length > max_size ? title.chars[0...max_size_truncate] + "..." : title).to_s
      twit.post "#{title} #{post_path(post.permalink)}" 
      post.update_attribute(:tweeted_at, Time.zone.now)
    end
  end

end

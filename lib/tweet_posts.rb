# script/runner -e production "require 'tweet_posts'; TweetPosts.execute" 

require 'twitter'

class TweetPosts

  def self.execute
    twit = Twitter::Base.new(ENV['TWITTER_USER'], ENV['TWITTER_PASS'])

    Post.find_latest(:limit => 50, :order => "published_at", :conditions => ["published_at < DATE_SUB(?, INTERVAL 5 MINUTE) AND tweeted_at IS NULL", Time.now.utc]).each do |post|
      signature = " enviado por " + (post.user.twitter_user.blank? ? "#{post.user.nick}" : "@#{post.user.twitter_user}") 
      max_size = 140 - signature.chars.length - 35 - 1 #(tinyurl: +-35, space: 1)
      max_size_truncate = max_size - "...".chars.length
      title = post.title.strip
      title = (title.chars.length > max_size ? title.chars[0...max_size_truncate] + "..." : title).to_s
      twit.post "#{title} http://rubyonda.com/artigos/#{post.permalink}#{signature}" 
      post.update_attribute(:tweeted_at, Time.zone.now)
    end
  end

end

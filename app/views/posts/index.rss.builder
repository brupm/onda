atom_feed(:url => @feed_url) do |feed|
  feed.title("Ruby Onda")
  feed.updated(@feed_updated)

  for post in @posts
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.content((post.description + "<br/><br/>" + "Link: #{link_to post.full_url}"), :type => 'html')
      
      entry.author do |author|
	      author.name(post.user.nick)
	      author.uri(post.user.url) unless post.user.url.blank?
      end
    end
  end
end
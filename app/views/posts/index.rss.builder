xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Ruby Onda"
    xml.description "Artigos selecionados para você no Ruby Onda!"
    xml.link formatted_posts_url(:rss)
    
    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.description
        xml.pubDate post.posted_at.to_time.rfc822
        xml.guid post.permalink
        xml.link post.full_url
        xml.author post.user.nick
      end
    end
  end
end
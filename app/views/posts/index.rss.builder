xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Ruby Onda"
    xml.description "Artigos selecionados para você no Ruby Onda!"
    xml.link root_url
    
    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.description
        xml.pubDate post.posted_at.to_time.rfc822
        xml.link post.permalink
        xml.author post.user.nick
      end
    end
  end
end
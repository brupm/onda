xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Ruby a Onda"
    xml.description "Artigos selecionados para você no Ruby a Onda!"
    xml.link formatted_posts_url(:rss)
    
    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.description
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link post.url
      end
    end
  end
end
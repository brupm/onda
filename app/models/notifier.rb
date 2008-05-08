class Notifier < ActionMailer::Base
  def new_post(post)
    recipients  ["bruno@bopia.com", "roberto@bopia.com"]
#    recipients User.find(:all, :conditions => {:admin => true}).collect(&:email).join(' ')
    from        "rubyonda@bopia.com"
    subject     "Novo artigo em RubyOnda: #{post.state_pt}"
    body        :post => post
  end
end

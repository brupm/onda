require 'md5'

module UsersHelper
  
  def avatar_tag(email, size = 40)
    email ||= ''
    image_tag("http://www.gravatar.com/avatar/#{MD5::md5(email.downcase)}?size=#{size}", :size => "#{size}x#{size}")
  end
  
end
WillPaginate::ViewHelpers.pagination_options[:prev_label] = '&laquo;  Página Anterior'
WillPaginate::ViewHelpers.pagination_options[:next_label] = 'Próxima Página &raquo;'

OpenIdAuthentication::Result::ERROR_MESSAGES.merge(
      :missing      => "Servidor OpenID não encontrado",
      :canceled     => "A verificação do OpenID foi cancelada",
      :failed       => "A verificação do OpenID falhou",
      :setup_needed => "A verificação do OpenID precisa ser configurada")
      

OVERLOAD_TO_PARAM = "yes"
TagList.delimiter = " "

# http://blog.codahale.com/2006/04/09/rails-environments-a-plugin-for-well-rails/
class Env
  def self.environment;   ENV['RAILS_ENV'].to_s.downcase end
  def self.development?;  (environment == 'development') end
  def self.production?;   (environment == 'production') end
  def self.test?;         (environment == 'test') end
  def self.none?;         environment.empty? end
end
      
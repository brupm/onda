WillPaginate::ViewHelpers.pagination_options[:prev_label] = '&laquo;  Página Anterior'
WillPaginate::ViewHelpers.pagination_options[:next_label] = 'Próxima Página &raquo;'

OpenIdAuthentication::Result::ERROR_MESSAGES = {
      :missing      => "Servidor OpenID não encontrado",
      :canceled     => "A verificação do OpenID foi cancelada",
      :failed       => "A verificação do OpenID falhou",
      :setup_needed => "A verificação do OpenID precisa ser configurada"
    }
namespace :hoptoad do
  desc "Verify your plugin installation by sending a test exception to the hoptoad service"
  task :test => :environment do
    require 'action_controller/test_process'
    require 'application'

    request = ActionController::TestRequest.new({
      'action'     => 'dummy_action',
      'controller' => 'application',
      '_method'    => 'GET'
    })

    response = ActionController::TestResponse.new

    class HoptoadTestingException < RuntimeError; end

    puts 'Setting up the Controller.'
    controller = ApplicationController.new
    class ApplicationController
      # This is to bypass any filters that may prevent access to the action.
      prepend_before_filter :test_hoptoad
      def test_hoptoad
        puts 'Raising an error to simulate application failure.'
        raise HoptoadTestingException, 'Testing hoptoad via "rake hoptoad:test". If you can see this, it works.'
      end

      # Ensure we actually have an action to go to.
      def dummy_action; end
    end

    puts 'Processing request.'
    controller.process(request, response)
  end
end


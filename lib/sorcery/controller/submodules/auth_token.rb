module Sorcery
  module Controller
    module Submodules
      module AuthToken
        def self.included(base)
          base.send(:include, InstanceMethods)
          Config.login_sources << :login_from_auth_token
        end

        module InstanceMethods

          protected

          def login_from_auth_token
            @current_user = (user_class.find_by_auth_token(auth_token)) if auth_token || false
            auto_login(@current_user) if @current_user
            @current_user
          end
          
          def auth_token
            params[:token] or request.env['TOKEN']
          end
        end
      end
    end
  end
end
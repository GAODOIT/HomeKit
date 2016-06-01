class BaseController < ApplicationController
    # disable the CSRF token
    protect_from_forgery with: :null_session

    # disable cookies (no set-cookies header in response)
    before_action :destroy_session

    # disable the CSRF token
    skip_before_action :verify_authenticity_token

    def destroy_session
        request.session_options[:skip] = true
    end

    def api_error(opts = {})
        render nothing: true, status: opts[:status]
    end
end

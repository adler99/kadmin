module RailsAdmin
  class AuthController < ApplicationController
    SESSION_KEY = 'rails_admin.user'.freeze

    # Don't try to authenticate user on the authentication controller...
    skip_before_action :authorize

    # @!group Endpoints
    # GET /auth/login
    def login
      render 'rails_admin/auth/login'
    end

    # GET /auth/logout
    # DELETE /auth/logout
    def logout
      session.delete(SESSION_KEY)
      redirect_to action: :login
    end

    # GET /auth/:provider/callback
    # POST /auth/:provider/callback
    def save
      auth_hash = request.env['omniauth.auth']

      if auth_hash.blank?
        RailsAdmin.logger.error('No authorization hash provided')
        flash.alert = I18n.t('rails_admin.auth.error')
        redirect_to action: :login
        return
      end

      email = auth_hash.dig('info', 'email')
      if RailsAdmin::Auth.users.exists?(email)
        session[SESSION_KEY] = email
        redirect_url = request.env['omniauth.origin']
        redirect_url = RailsAdmin.config.mount_path unless valid_redirect_url?(redirect_url)
      else
        flash.alert = I18n.t('rails_admin.auth.unauthorized_message')
        redirect_url = url_for(action: :login)
      end

      redirect_to redirect_url
    end

    # GET /auth/failure
    def failure
      flash.alert = params[:message]
      redirect_to action: :login
    end

    def unauthorized
      render 'rails_admin/error', format: ['html'], locals: {
        title: I18n.t('rails_admin.auth.unauthorized'),
        message: I18n.t('rails_admin.auth.unauthorized_message')
      }
    end

    # @!endgroup

    # @!group Helpers

    def valid_redirect_url?(url)
      valid = false

      unless url.blank?
        paths = [url_for(action: :login), url_for(action: :logout)]
        valid = paths.none? { |invalid| url == invalid }
      end

      return valid
    end
    protected :valid_redirect_url?

    def omniauth_provider_link
      auth_prefix = "#{RailsAdmin.config.mount_path}/auth"
      provider_link = "#{auth_prefix}/#{RailsAdmin::Auth.omniauth_provider}"
      origin = params[:origin]

      # if the referer is a auth route, then we risk ending in an endless loop
      if origin.blank?
        referer = request.referer
        if referer.blank?
          origin = RailsAdmin.config.mount_path
        else
          uri = URI(referer)
          origin = referer unless uri&.path&.start_with?(auth_prefix)
        end
      end

      provider_link = "#{provider_link}?origin=#{CGI.escape(origin)}" unless origin.blank?
      return provider_link
    end
    helper_method :omniauth_provider_link

    # @!endgroup
  end
end

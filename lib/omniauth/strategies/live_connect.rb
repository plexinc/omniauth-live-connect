require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class LiveConnect < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'wl.basic,wl.emails'

      option :name, 'live_connect'
      option :client_options, {
        :site => 'https://login.live.com',
        :authorize_url => '/oauth20_authorize.srf',
        :token_url => '/oauth20_token.srf'
      }
      option :authorize_params, {
        :response_type => 'code'
      }

      def callback_url
        super.sub('http:', 'https:')
      end

      def request_phase
        super
      end

      uid { raw_info['id'].to_s }

      info do
        {
          'name' => raw_info['name'],
          'first_name' => raw_info['first_name'],
          'last_name' => raw_info['last_name'],
          'email' => raw_info['emails']['preferred']
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        @raw_info ||= access_token.get('https://apis.live.net/v5.0/me').parsed
      end

    end
  end
end

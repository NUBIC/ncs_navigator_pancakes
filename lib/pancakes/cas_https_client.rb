require 'aker'
require 'castanet'
require 'faraday'
require 'faraday_middleware'

##
# Makes HTTPS requests to NCS Navigator Web services.
#
# Features:
#
# - Adds X-Client-ID headers
# - Generates a unique CAS PT for each request (or fails immediately if a PT
#   cannot be generated)
module Pancakes::CasHttpsClient
  CLIENT_ID = 'b093942e-ad30-11e2-805c-b8f6b111aef5'

  ##
  # Generates a Faraday object configured for Pancakes' use.
  #
  # You MUST specify at least the :url and :pgt parameters.
  #
  # All options given to this method, with the exception of :pgt, are passed
  # directly to Faraday.
  def client(options = {})
    pgt = options.delete(:pgt)
    url = options[:url]
    raise 'URL not given' unless url
    raise 'PGT not given' unless pgt

    options.update(:headers => {
      'X-Client-ID' => CLIENT_ID
    })

    Faraday.new(options) do |f|
      f.request :cas_proxy_auth, pgt, url
      f.response :json, :content_type => %r{\bjson\Z}
      f.adapter :net_http
    end
  end

  class CasProxyAuth < Faraday::Middleware
    include Castanet::Client

    def initialize(app, pgt, service_url)
      super(app)

      @pgt = pgt
      @service_url = service_url
    end

    def call(env)
      pt = issue_proxy_ticket(@pgt, @service_url)
      env[:request_headers]['Authorization'] = 'CasProxy ' + pt.to_s
      @app.call(env)
    end

    def cas_url
      "#{Aker.configuration.parameters_for(:cas)[:base_url]}/"
    end
  end

  Faraday::Request.register_middleware :cas_proxy_auth => CasProxyAuth
end

# vim:ts=2:sw=2:et:tw=78

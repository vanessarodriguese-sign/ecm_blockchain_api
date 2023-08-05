require 'httparty'

module ECMBlockchain
  module Request
    def self.extended(base)
      base.include HTTParty
    end
    
    HTTP_VERBS = %i(post get delete patch)

    private

    def request(method, url, data=nil)
      ECMBlockchain.has_api_key?
      check_http_verb(method)
      response = api_client_call(method, url, data)
      raise ECMBlockchain::Error.from_response(response) unless response.success?
      JSON.parse(response.body).deep_symbolize_keys if response.body
    end

    def api_client_call(verb, url, data)
      args = [ verb, ECMBlockchain.base_url + url ]
      headers = {}
      headers[:body] = data.to_json if data
      headers.merge! request_headers
      args.push(headers)
      self.send *args
    end

    def check_http_verb(verb)
      unless HTTP_VERBS.include?(verb)
        raise BadRequestError, 
          "HTTP Verb needs to be one of the following: #{ HTTP_VERBS }"
      end
    end

    def request_headers
      { :headers => {"Content-Type" => "application/json", "Authorization" => "Bearer #{ECMBlockchain.access_token}"} }
    end
  end
end

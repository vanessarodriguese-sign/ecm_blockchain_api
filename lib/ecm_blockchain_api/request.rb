require 'httparty'

module ECMBlockchain
  module Request
    def self.extended(base)
      base.include HTTParty
    end
    
    HTTP_VERBS = %i(post get delete patch)

    def request(method, url, data=nil)
      ECMBlockchain.has_api_key?
      check_http_verb(method)
      api_client(method, url, data)
    end

    def api_client(verb, url, data)
      args = [ verb, ECMBlockchain.base_url + url ]
      headers = {}
      headers[:body] = data.to_json if data
      headers.merge! request_headers
      args.push(headers)
      self.send *args
    end

    def return_any_errors(response)
      raise BadResponseError, "The response returned no data" if response.to_s.empty?
      return unless response.body && response.body.include?("statusCode") && response.body.include?("message")
      parse_error(response.body)
    end

    private

    def parse_error(response)
      err = JSON.parse(response)
      error = Object.const_get("ECMBlockchain::#{err["name"]}")
      return error.new err["message"], err["statusCode"]
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

require 'httparty'

module ECMBlockchain
  module Request
    def self.extended(base)
      base.include HTTParty
    end
    
    HTTP_VERBS = %i(post get delete patch)

    def request(method, url, data="")
      ECMBlockchain.has_api_key?
      check_http_verb(method)
      api_client(method, url)
    end

    def api_client(verb, url)
      self.send verb, ECMBlockchain.base_url + url
    end

    private

    def check_http_verb(verb)
      unless HTTP_VERBS.include?(verb)
        raise BadRequestError, 
          "HTTP Verb needs to be one of the following: #{ HTTP_VERBS }"
      end
    end
  end
end

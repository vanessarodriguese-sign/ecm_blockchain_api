module ECMBlockchain
  class Client
    def initialize(access_token=nil)
      @access_token = access_token || ENV['ECM_ACCESS_TOKEN']
    end
  end
end

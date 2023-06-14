module ECMBlockchain
  class ECMBlockchainError < StandardError
    attr_accessor :code

    def initialize(message=nil, code=nil)
      super(message)
      @code = code
    end

    def success?
      false
    end

    def error
      self
    end

    def identifier
      self.class.to_s.split('::')[1]
    end

    def method_missing(method, *args)
      raise self.class.new, message
    end
  end

  class AuthenticationError < ECMBlockchainError; end
  class BadRequestError < ECMBlockchainError; end
  class UnprocessableEntityError < ECMBlockchainError; end
  class NotFoundError < ECMBlockchainError; end
end

module ECMBlockchain
  class Error < StandardError
    attr_reader :code, :details

    ClientError = Class.new(self)

    BadRequest = Class.new(ClientError)
    Unauthorized = Class.new(ClientError)
    PaymentRequired = Class.new(ClientError)
    Forbidden = Class.new(ClientError)
    RequestEntityTooLarge = Class.new(ClientError)
    NotFound = Class.new(ClientError)
    NotAcceptable = Class.new(ClientError)
    UnprocessableEntity = Class.new(ClientError)
    TooManyRequests = Class.new(ClientError)

    ServerError = Class.new(self)
    InternalServerError = Class.new(ServerError)
    BadGateway = Class.new(ServerError)
    ServiceUnavailable = Class.new(ServerError)
    GatewayTimeout = Class.new(ServerError)

    TimeoutError = Class.new(self)

    ERRORS = {
      400 => ECMBlockchain::Error::BadRequest,
      401 => ECMBlockchain::Error::Unauthorized,
      402 => ECMBlockchain::Error::PaymentRequired,
      403 => ECMBlockchain::Error::Forbidden,
      404 => ECMBlockchain::Error::NotFound,
      406 => ECMBlockchain::Error::NotAcceptable,
      413 => ECMBlockchain::Error::RequestEntityTooLarge,
      422 => ECMBlockchain::Error::UnprocessableEntity,
      429 => ECMBlockchain::Error::TooManyRequests,
      500 => ECMBlockchain::Error::InternalServerError,
      502 => ECMBlockchain::Error::BadGateway,
      503 => ECMBlockchain::Error::ServiceUnavailable,
      504 => ECMBlockchain::Error::GatewayTimeout,
    }.freeze

    class << self
      # Create a new error from an HTTP response
      #
      def from_response(response)
        klass = ERRORS[response.code] || self
        err = JSON.parse(response.body).deep_symbolize_keys[:error]
        klass.new(err[:message], err[:statusCode], err[:details])
      end
    end

    # Initializes a new Error object
    #
    # @param message [Exception, String]
    # @param code [Integer]
    # @return [ECMBlockchain::Error]
    def initialize(message = "", code = nil, details = nil)
      super(message)

      @code = code
      @details = details
    end
  end
end

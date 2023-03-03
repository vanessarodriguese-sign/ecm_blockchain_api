module ECMBlockchain
  class ECMBlockchainError < StandardError

  end
  class AuthenticationError < ECMBlockchainError; end
  class BadRequestError < ECMBlockchainError; end
end

module ECMBlockchain
  class CA
    extend ECMBlockchain::Routes
    extend ECMBlockchain::Request

    class << self
      def create(data)
        response = request( :post, MEMBERS_URL, data )
        # return_any_errors(response)
        # Member.new response
      end
    end
  end
end

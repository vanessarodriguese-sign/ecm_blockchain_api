module ECMBlockchain
  class CA
    extend ECMBlockchain::Routes
    extend ECMBlockchain::Request

    class << self
      def create(data)
        error_or_member(request( :post, MEMBERS_URL, data ))
      end

      def retrieve(identity)
        error_or_member(request( :get, "/#{identity}#{MEMBERS_URL}" ))
      end

      def update(identity, data)
        error_or_member(request( :patch, "/#{identity}#{MEMBERS_URL}", data ))
      end

      def revoke(identity)
        response = request( :delete, "/#{identity}#{MEMBERS_URL}")
        return_any_errors(response) ||   
        OpenStruct.new(success: true, details: "Certificate successfully revoked")
      end

      private

      def error_or_member(response)
        return_any_errors(response) ||
        ECMBlockchain::Member.new(JSON.parse(response.body).with_indifferent_access)
      end
    end
  end
end

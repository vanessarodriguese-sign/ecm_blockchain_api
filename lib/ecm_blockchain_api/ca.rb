module ECMBlockchain
  class CA
    extend ECMBlockchain::Routes
    extend ECMBlockchain::Request

    class << self
      def create(data)
        member(request( :post, MEMBERS_URL, data ))
      end

      def retrieve(identity)
        member(request( :get, "/#{identity}#{MEMBERS_URL}" ))
      end

      def update(identity, data)
        member(request( :patch, "/#{identity}#{MEMBERS_URL}", data ))
      end

      def revoke(identity)
        response = request( :delete, "/#{identity}#{MEMBERS_URL}")
        OpenStruct.new(success: true, details: "Certificate successfully revoked")
      end

      private

      def member(params)
        ECMBlockchain::Member.new(params)
      end
    end
  end
end

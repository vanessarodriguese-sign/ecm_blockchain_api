module ECMBlockchain
  class Asset
    extend ECMBlockchain::Routes
    extend ECMBlockchain::Request

    class << self
      def create(identity, data)
        response = request( :post, "/#{identity}/#{ASSET_URL}", data )
        binding.pry
        return_any_errors(response)
        ECMBlockchain::Asset.new(JSON.parse(response.body).with_indifferent_access)
      end

      # def retrieve(identity)
      #   response = request( :get, "/#{identity}#{MEMBERS_URL}" )
      #   return_any_errors(response)
      #   ECMBlockchain::Member.new(JSON.parse(response.body).with_indifferent_access)
      # end

      # def update(identity, data)
      #   response = request( :patch, "/#{identity}#{MEMBERS_URL}", data )
      #   return_any_errors(response)
      #   ECMBlockchain::Member.new(JSON.parse(response.body).with_indifferent_access)
      # end

      # def revoke(identity)
      #   response = request( :delete, "/#{identity}#{MEMBERS_URL}")
      #   return_any_errors(response)
      #   OpenStruct.new(success: true, details: "Certificate successfully revoked")
      # end
    end
  end
end

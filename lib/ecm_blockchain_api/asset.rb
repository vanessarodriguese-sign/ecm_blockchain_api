module ECMBlockchain
  class Asset
    extend ECMBlockchain::Routes
    extend ECMBlockchain::Request

    class << self
      def create(identity, data)
        verify_asset(data)
        asset(request( :post, "/#{identity}#{ASSET_URL}", data ))
      rescue => error; error
      end

      def batch_create(identity, data)
        verify_batch_assets(data)
        request( :post, "/#{identity}#{ASSET_BATCH_URL}", data ). 
          collect { |asset_response| asset(asset_response) }
      rescue => error; error
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
      private 

      def asset(asset_data) 
        ECMBlockchain::AssetModel.new(asset_data)
      end

      def verify_asset(asset)
        ECMBlockchain::AssetModel.verify(asset) 
      end

      def verify_batch_assets(arr)
        arr.find_all { |asset| verify_asset(asset) }  
      end
    end
  end
end

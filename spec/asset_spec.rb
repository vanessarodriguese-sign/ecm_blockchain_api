# frozen_string_literal: true

RSpec.describe ECMBlockchain::Asset do
  let!(:initialise) do
    ECMBlockchain.access_token = "test12345"
  end

  let(:assets_url) { '/assets' }
  let(:batch_assets_url) { '/batch_assets' }
  let(:asset_request) do
    asset_request_data
  end

  let(:asset_response) do
    asset_response_data
  end

  describe '#create' do
    let(:identity) { "user@org1.example.com:s3cr3t!" }
    before do
      stub_request(:post, ECMBlockchain.base_url + "/#{identity}#{assets_url}")
    end
    
    context 'asset created' do
      context '200 - with data' do
        before do
          allow(ECMBlockchain::Asset).to receive(:request).and_return(asset_response)
        end

        it 'should return an asset' do
          asset = ECMBlockchain::Asset.create(identity, asset_request)
          expect(asset.uuid).to eq(asset_response[:uuid])
        end

        it 'should return an success on an asset' do
          asset = ECMBlockchain::Asset.create(identity, asset_request)
          expect(asset.success?).to eq(true)
        end

        it 'should call the request method with the correct params' do
          expect(ECMBlockchain::Asset).to receive(:request)
            .with( :post, "/#{identity}#{assets_url}", asset_request ).and_return(
              OpenStruct.new(body: asset_response.to_json)
            )
          ECMBlockchain::Asset.create(identity, asset_request)
        end
      end

      context '422' do
        let(:error_response) do
          {
            code: 422,
            body: {
              statusCode: 422,
              name: 'UnprocessableEntityError',
              message: 'error message'
            }
          }
        end

        before do
          allow(ECMBlockchain::Asset).to receive(:api_client_call).and_return(error_response)
        end

        it 'should return a UnprocessableEntityError' do
          asset = ECMBlockchain::Asset.create(identity, asset_request) 
          expect(asset.success?).to eq(false)
          expect(asset.error.message).to eq('error message')
          expect(asset.error.code).to eq(422)
          expect(asset.error.identifier).to eq('UnprocessableEntityError')
        end

        it 'should return the error message' do
          asset = ECMBlockchain::Asset.create(identity, asset_request) 
          expect{ asset.wrong }.to raise_error(ECMBlockchain::UnprocessableEntityError)
        end
      end
    end
  end

  describe '#batch_create' do
    let(:identity) { "user@org1.example.com:s3cr3t!" }
    
    context 'batch asset created' do
      before do
        stub_request(:post, ECMBlockchain.base_url + "/#{identity}#{batch_assets_url}")
      end

      context '200 - with data' do
        before do
          allow(ECMBlockchain::Asset).to receive(:request).and_return([asset_response])
        end

        it 'should return the assets' do
          res = ECMBlockchain::Asset.batch_create(identity, [asset_request])
          expect(res).to be_a(Array)
          expect(res.length).to eq(1)
          expect(res[0].uuid).to eq(asset_response[:uuid])
        end

        # it 'should return an success on an asset' do
        #   asset = ECMBlockchain::Asset.create(identity, asset_request)
        #   expect(asset.success?).to eq(true)
        # end

        # it 'should call the request method with the correct params' do
        #   expect(ECMBlockchain::Asset).to receive(:request)
        #     .with( :post, "/#{identity}#{assets_url}", asset_request ).and_return(
        #       OpenStruct.new(body: asset_response.to_json)
        #     )
        #   ECMBlockchain::Asset.create(identity, asset_request)
        # end
      end

      context '422' do
        let(:error_response) do
          {
            code: 422,
            body: {
              statusCode: 422,
              name: 'UnprocessableEntityError',
              message: 'error message'
            }
          }
        end

        before do
          allow(ECMBlockchain::Asset).to receive(:api_client_call).and_return(error_response)
        end

        it 'should return a UnprocessableEntityError' do
          asset = ECMBlockchain::Asset.create(identity, asset_request) 
          expect(asset.success?).to eq(false)
          expect(asset.error.message).to eq('error message')
          expect(asset.error.code).to eq(422)
          expect(asset.error.identifier).to eq('UnprocessableEntityError')
        end

        it 'should return the error message' do
          asset = ECMBlockchain::Asset.create(identity, asset_request) 
          expect{ asset.wrong }.to raise_error(ECMBlockchain::UnprocessableEntityError)
        end
      end
    end
  end

  # describe '#retrieve' do
  #   let(:identity) { "user@org1.example.com:s3cr3t!" }
  #   context '200' do
  #     before do
  #       stub_request(:get, ECMBlockchain.base_url + "/#{identity}#{assets_url}")
  #         .to_return(status: 200, body: member_response.to_json)
  #     end

  #     it 'should retrieve a member' do
  #       member = ECMBlockchain::CA.retrieve(identity)
  #       expect(member.uuid).to eq(member_response[:uuid])
  #       expect(member.organisation).to eq(member_response[:organisation])
  #     end
      
  #     it 'should retrieve a members custom attributes' do
  #       member = ECMBlockchain::CA.retrieve(identity)
  #       expect(member.custom_attributes.count).to eq(member_response[:customAttributes].count)
  #       expect(member.custom_attributes[0]).to be_kind_of(ECMBlockchain::CustomAttribute)
  #       expect(member.custom_attributes[0].name).to eq(member_response[:customAttributes][0][:name])
  #       expect(member.custom_attributes[0].value).to eq(
  #         member_response[:customAttributes][0][:value]
  #       )
  #     end
  #   end
  # end

  # describe '#update' do
  #   let(:identity) { "user@org1.example.com:s3cr3t!" }
  #   let(:patch_request) do
  #     {
  #       customAttributes: [
  #         {
  #           name: "ecm.verified_by",
  #           value: "Verification Authority"
  #         }
  #       ]
  #     }
  #   end

  #   let(:patch_member_response) do
  #     member_response[:customAttributes] << patch_request[:customAttributes][0]
  #     member_response
  #   end

  #   context '200' do
  #     before do
  #       stub_request(:patch, ECMBlockchain.base_url + "/#{identity}#{assets_url}")
  #         .to_return(status: 200, body: patch_member_response.to_json)
  #     end

  #     it 'should call the request method with the correct params' do
  #       expect(ECMBlockchain::CA).to receive(:request)
  #         .with( :patch, "/#{identity}/members", patch_request ).and_return(
  #           OpenStruct.new(body: patch_member_response.to_json)
  #         )
  #       ECMBlockchain::CA.update(identity, patch_request)
  #     end
      
  #     it 'should retrieve a members updated custom attributes' do
  #       member = ECMBlockchain::CA.update(identity, patch_request)
  #       expect(member.custom_attributes.count).to eq(patch_member_response[:customAttributes].count)
  #       expect(member.custom_attributes[1].name).to eq(member_response[:customAttributes][1][:name])
  #       expect(member.custom_attributes[1].value).to eq(
  #         member_response[:customAttributes][1][:value]
  #       )
  #     end
  #   end
  # end

  # describe '#revoke' do
  #   let(:identity) { "user@org1.example.com:s3cr3t!" }
  #   context '204' do
  #     before do
  #       stub_request(:delete, ECMBlockchain.base_url + "/#{identity}#{assets_url}")
  #         .to_return(status: 204, body: '{}')
  #     end

  #     it 'should revoke a member' do
  #       response = ECMBlockchain::CA.revoke(identity)
  #       expect(response.success).to eq(true)
  #       expect(response.details).to eq("Certificate successfully revoked")
  #     end
  #   end
  # end
end

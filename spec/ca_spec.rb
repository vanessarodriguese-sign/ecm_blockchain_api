# frozen_string_literal: true


RSpec.describe ECMBlockchain::CA do
  let!(:initialise) do
    ECMBlockchain.access_token = "test12345"
  end

  let(:members_url) { '/members' }
  let(:member_response) do
    {
      uuid: "user@org1.example.com",
      organisation: "Org1",
      customAttributes: [
        {
          name: "verified",
          value: "true"
        }
      ]
    }
  end
  let(:request) do
    {
      "uuid": "user@org1.example.com",
      "secret": "s3cr3t!",
      "customAttributes": [
        {
          "name": "verified",
          "value": "true"
        }
      ]
    }
  end

  describe '#create' do
    before do
      stub_request(:post, ECMBlockchain.base_url + members_url)
    end

    context 'member created' do
      context '200 - with data' do
        before do
          allow(ECMBlockchain::CA).to receive(:request).and_return(member_response)
        end

        it 'should return a member' do
          member = ECMBlockchain::CA.create(request)
          expect(member.uuid).to eq(member_response[:uuid])
          expect(member.organisation).to eq(member_response[:organisation])
        end

        it 'should call the request method with the correct params' do
          expect(ECMBlockchain::CA).to receive(:request)
            .with( :post, '/members', request )
          ECMBlockchain::CA.create(request)
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
          allow(ECMBlockchain::CA).to receive(:api_client_call).and_return(error_response)
        end

        it 'should return a UnprocessableEntityError' do
          member = ECMBlockchain::CA.create(request) 
          expect(member.success?).to eq(false)
          expect(member.error.message).to eq('error message')
          expect(member.error.code).to eq(422)
          expect(member.error.identifier).to eq('UnprocessableEntityError')
        end

        it 'should return a UnprocessableEntityError method_missing' do
          member = ECMBlockchain::CA.create(request) 
          expect{ member.wrong }.to raise_error(ECMBlockchain::UnprocessableEntityError)
        end

        it 'should return the error message' do
          begin
            ECMBlockchain::CA.create(request)
          rescue => e
            expected_error = JSON.parse(error_response)
            expect(e.message).to eq(expected_error["message"])
            expect(e.code).to eq(expected_error["statusCode"])
          end
        end
      end
    end
  end

  describe '#retrieve' do
    before do
      stub_request(:get, ECMBlockchain.base_url + members_url)
    end

    let(:identity) { "user@org1.example.com:s3cr3t!" }

    context '200' do
      before do
        allow(ECMBlockchain::CA).to receive(:request).and_return(member_response)
      end

      it 'should retrieve a member' do
        member = ECMBlockchain::CA.retrieve(identity)
        expect(member.uuid).to eq(member_response[:uuid])
        expect(member.organisation).to eq(member_response[:organisation])
      end
      
      it 'should retrieve a members custom attributes' do
        member = ECMBlockchain::CA.retrieve(identity)
        expect(member.custom_attributes.count).to eq(member_response[:customAttributes].count)
        expect(member.custom_attributes[0]).to be_kind_of(ECMBlockchain::CustomAttribute)
        expect(member.custom_attributes[0].name).to eq(member_response[:customAttributes][0][:name])
        expect(member.custom_attributes[0].value).to eq(
          member_response[:customAttributes][0][:value]
        )
      end
    end
  end

  describe '#update' do
    before do
      stub_request(:patch, ECMBlockchain.base_url + "/#{identity}#{members_url}")
    end

    let(:identity) { "user@org1.example.com:s3cr3t!" }
    let(:patch_request) do
      {
        customAttributes: [
          {
            name: "ecm.verified_by",
            value: "Verification Authority"
          }
        ]
      }
    end

    let(:patch_member_response) do
      member_response[:customAttributes] << patch_request[:customAttributes][0]
      member_response
    end

    context '200' do
      before do
        allow(ECMBlockchain::CA).to receive(:request).and_return(patch_member_response)
      end

      it 'should call the request method with the correct params' do
        expect(ECMBlockchain::CA).to receive(:request)
          .with( :patch, "/#{identity}/members", patch_request )
        ECMBlockchain::CA.update(identity, patch_request)
      end
      
      it 'should retrieve a members updated custom attributes' do
        member = ECMBlockchain::CA.update(identity, patch_request)
        expect(member.custom_attributes.count).to eq(patch_member_response[:customAttributes].count)
        expect(member.custom_attributes[1].name).to eq(member_response[:customAttributes][1][:name])
        expect(member.custom_attributes[1].value).to eq(
          member_response[:customAttributes][1][:value]
        )
      end
    end
  end

  describe '#revoke' do
    let(:identity) { "user@org1.example.com:s3cr3t!" }
    before do
      stub_request(:delete, ECMBlockchain.base_url + "/#{identity}#{members_url}")
    end

    context '204' do
      before do
        allow(ECMBlockchain::CA).to receive(:request).and_return('{}')
      end

      it 'should revoke a member' do
        response = ECMBlockchain::CA.revoke(identity)
        expect(response.success).to eq(true)
        expect(response.details).to eq("Certificate successfully revoked")
      end
    end
  end
end

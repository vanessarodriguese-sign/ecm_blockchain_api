# frozen_string_literal: true


RSpec.describe ECMBlockchain::CA do
  describe '#create' do
    let!(:initialise) do
      ECMBlockchain.access_token = "test12345"
    end

    context 'member created' do
      let(:data) do
        ""
      end

      before do
        # mock success
      end

      it 'should return data' do
        expect(ECMBlockchain::CA.create(data)).to eq("works")
      end

      it 'should call the request method with the correct params' do
        expect(ECMBlockchain::CA).to receive(:request)
              .with( :post, '/members', data )
        ECMBlockchain::CA.create(data)
      end
      it 'should return a member'
    end

  end
end

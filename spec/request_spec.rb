RSpec.describe ECMBlockchain::Request do
  let(:request_class) do
    class Test
      extend ECMBlockchain::Request
    end
  end

  let(:verb) { :post }
  let(:url)  { ECMBlockchain::Routes::MEMBERS_URL }
  let(:data) { "" }

  describe '#request' do
    it 'should throw an error if no API key' do
      ECMBlockchain.access_token = ''
      expect{ request_class.request(verb, url, data) }
        .to raise_error(ECMBlockchain::AuthenticationError)
    end
    
    it 'should throw an error if the method isnt included' do
      expect{ request_class.request(:wrong, url, data) }
        .to raise_error(ECMBlockchain::BadRequestError)
    end

    it 'should call api_client' do
      expect(request_class).to receive(:api_client)
      request_class.request(verb, url, data)
    end
  end

  describe '#api_client' do
    it 'should call the verb' do
      expect(request_class).to receive(:get)
      request_class.api_client(:get, ECMBlockchain::Routes::MEMBERS_URL)
    end
  end
end

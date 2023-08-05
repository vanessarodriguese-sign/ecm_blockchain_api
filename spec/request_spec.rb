RSpec.describe ECMBlockchain::Request do
  before { stub_request(:get, ECMBlockchain.base_url + ECMBlockchain::Routes::MEMBERS_URL) }

  let(:request_class) do
    class Test
      extend ECMBlockchain::Request
    end
  end

  let(:verb) { :post }
  let(:url)  { ECMBlockchain::Routes::MEMBERS_URL }
  let(:header) do
    { "Authorization" => "Bearer abc123", "Content-Type" => "application/json" }  
  end
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
      request_class.api_client(:get, ECMBlockchain::Routes::MEMBERS_URL, nil)
    end

    it 'should call the endpoint with the correct data' do
      expect(request_class).to receive(:post)
        .with(
          ECMBlockchain.base_url + ECMBlockchain::Routes::MEMBERS_URL,
          body: { member: "test" }.to_json,
          headers: header
        )
      request_class.api_client(:post, ECMBlockchain::Routes::MEMBERS_URL, { member: "test" })
    end

    it 'should call get endpoint with no data' do
      expect(request_class).to receive(:get)
        .with(
          ECMBlockchain.base_url + ECMBlockchain::Routes::MEMBERS_URL,
          headers: header
        )
      request_class.api_client(:get, ECMBlockchain::Routes::MEMBERS_URL, nil)
    end
  end

  describe '#return_any_errors' do
    let(:ecm_response) do
      OpenStruct.new(
        body: { error: { 
          code: 422, 
          type: "UnprocessableEntity",
          details: "error message abc"
          }
        }.to_json,
        code: 422,
      )
    end

    it 'should raise an error if no response' do
      expect{ request_class.return_any_errors("") }
        .to raise_error(ECMBlockchain::BadResponseError, "The response returned no data")
    end

    it 'should not raise an error' do
      response.body = { member: "one", code: 200 }
      expect{ request_class.return_any_errors(response) }
        .to_not raise_error
    end

    it 'should raise an UnprocessableEntityError' do
      response = request_class.return_any_errors(ecm_response.body) 
      expect(response).to be_a(ECMBlockchain::UnprocessableEntityError)
    end

    it 'should contain the error status code' do
      request_class.return_any_errors(response)
    rescue ECMBlockchain::UnprocessableEntityError => e
      expect(e.code).to eq(422)
    end

    it 'should contain the error status code' do
      request_class.return_any_errors(response)
    rescue ECMBlockchain::UnprocessableEntityError => e
      expect(e.message).to eq('error message abc')
    end
  end
end

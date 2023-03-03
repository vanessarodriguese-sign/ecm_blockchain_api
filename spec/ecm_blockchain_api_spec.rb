# frozen_string_literal: true

RSpec.describe ECMBlockchain do
  it "has a version number" do
    expect(ECMBlockchain::VERSION).not_to be nil
  end
  
  describe "#access_token" do
    it "allows to set the access token" do
      expect(ECMBlockchain.access_token).to eq("abc123")
    end
  end

  describe "#logger" do
    it "is set by default to" do
      expect(ECMBlockchain.logger).to be_a(Logger)
    end

    it "can be changed" do
      new_logger = ECMBlockchain.logger = Logger.new(STDERR)
      expect(ECMBlockchain.logger).to eq(new_logger)
    end
  end

  describe "#base_url" do
    it "is set by default to" do
      expect(ECMBlockchain.base_url).to eq("https://api.ecmsecure.com/v1")
    end

    it "can be changed" do
      new_base_url = ECMBlockchain.base_url = "https://sandbox.ecmsecure.com/v1"
      expect(ECMBlockchain.base_url).to eq(new_base_url)
    end
  end

  describe '#has_api_key?' do
    it 'should raise an Authentication error if no API key' do
      ECMBlockchain.access_token = ''
      expect{ ECMBlockchain.has_api_key? }.to raise_error(ECMBlockchain::AuthenticationError)
    end
  end
end

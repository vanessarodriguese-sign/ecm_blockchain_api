RSpec.describe ECMBlockchain::DataContent, type: :model do
  subject do
    data = content_response_data 
    ECMBlockchain::DataContent.new(data)
  end

  it { is_expected.to be_valid }

  it { is_expected.to respond_to(:test_name) }
  it { is_expected.to respond_to(:test_value) }
  it { is_expected.to respond_to(:test_access_date) }

  describe '#validations' do

  end
end

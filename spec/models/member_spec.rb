RSpec.describe ECMBlockchain::Member, type: :model do
  subject do
    data = {
      "uuid": "user112233@org1.example.com",
      "organisation": "example",
      "certificate": "cert",
      "customAttributes": [
        {
          "name": "verified",
          "value": "true"
        }
      ]
    } 
    ECMBlockchain::Member.new(data)
  end

  it { is_expected.to respond_to(:uuid) }
  it { is_expected.to respond_to(:organisation) }
  it { is_expected.to respond_to(:certificate) }
  it { is_expected.to respond_to(:custom_attributes) }

  describe '#validations' do
    it { is_expected.to validate_presence_of :uuid } 
    it { is_expected.to validate_presence_of :organisation } 
    it { is_expected.to validate_presence_of :certificate } 
  end
end

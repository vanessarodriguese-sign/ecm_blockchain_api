RSpec.describe ECMBlockchain::Member, type: :model do
  subject do
    data = {
      "uuid": "user112233@org1.example.com",
      "organisation": "example",
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
  it { is_expected.to respond_to(:customAttributes) }

  describe '#validations' do
    it { is_expected.to validate_presence_of :uuid } 
    it { is_expected.to validate_presence_of :organisation } 
  end
end

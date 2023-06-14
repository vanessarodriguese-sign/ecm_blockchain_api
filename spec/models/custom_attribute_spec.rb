RSpec.describe ECMBlockchain::CustomAttribute, type: :model do
  subject do
    data = {
      "name": "verified",
      "value": "true"
    } 
    ECMBlockchain::CustomAttribute.new(data)
  end

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:value) }

  describe '#validations' do
    it { is_expected.to validate_presence_of :name } 
    it { is_expected.to validate_presence_of :value } 
  end
end

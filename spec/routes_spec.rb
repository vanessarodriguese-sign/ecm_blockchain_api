RSpec.describe ECMBlockchain::Routes do
  it 'returns MEMBERS_URL' do
    expect(ECMBlockchain::Routes::MEMBERS_URL).to eq('/members')
  end
end

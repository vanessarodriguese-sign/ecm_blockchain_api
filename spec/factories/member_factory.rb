require 'faker' 

FactoryBot.define do
  factory :member, class: "ECMBlockchain::Member" do
    uuid { Faker::Internet.uuid }
    organisation { Faker::Company.name }
  end
end

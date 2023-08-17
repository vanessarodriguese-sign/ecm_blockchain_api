require 'active_model'

module ECMBlockchain
  class Member
    include ActiveModel::Validations

    attr_accessor :uuid, :organisation, :custom_attributes, :certificate

    validates :uuid, presence: true
    validates :organisation, presence: true

    def initialize(data={})
      @uuid = data.fetch(:uuid)
      @organisation = data.fetch(:organisation)
      @certificate = data.fetch(:certificate)
      @custom_attributes = data[:customAttributes].map do |attr|
        ECMBlockchain::CustomAttribute.new(attr)
      end
      # raise error unless valid
    end
  end
end

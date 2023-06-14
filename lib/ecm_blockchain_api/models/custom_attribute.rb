require 'active_model'

module ECMBlockchain
  class CustomAttribute
    include ActiveModel::Validations

    attr_accessor :name, :value

    validates :name, presence: true
    validates :value, presence: true
    
    def initialize(data = {})
      @name = data.fetch(:name)
      @value = data.fetch(:value)
    end
  end
end

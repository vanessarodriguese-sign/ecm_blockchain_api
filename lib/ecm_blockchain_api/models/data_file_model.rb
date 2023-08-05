module ECMBlockchain
  class DataFile
    include ActiveModel::Validations

    attr_accessor :title, :base64
    attr_reader :fileHash, :path, :fileValidated

    validates :title, :base64, presence: true

    def initialize(data={})
      data ||= {}
      @title = data[:title]
      @base64 = data[:base64]
      @fileHash = data[:fileHash]
      @path = data[:path]
      @fileValidated = data[:fileValidated]
    end

    def added?
      self.valid?
    end
  end
end

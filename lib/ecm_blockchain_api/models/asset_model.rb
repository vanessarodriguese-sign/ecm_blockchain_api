require 'active_model'

module ECMBlockchain
  class Asset
    include ActiveModel::Validations

    attr_accessor :uuid, :txId, :groupId, :title, :summary, :createdBy,
                  :file, :content, :created_at

    validates :uuid, :txId, :title, :summary, :createdBy, presence: true
    validate :data_file_or_content?
    validate :file_correct?

    def initialize(data={})
      @uuid = data.fetch(:uuid)
      @txId = data.fetch(:txId)
      @groupId = data.fetch(:groupId)
      @title = data.fetch(:title)
      @summary = data.fetch(:summary)
      @createdBy = data.fetch(:createdBy)
      @file = ECMBlockchain::DataFile.new(data[:file])
      @content = ECMBlockchain::DataContent.new(data[:content])
    end

    def success?
      true
    end

    def error
      nil
    end

    private

    def data_file_or_content?
      unless @file.added? || @content.added?
        errors.add(:base, "Please supply either a file object or content object")
      end
    end

    def file_correct?
      @file.valid? if @file.added?
    end
  end
end

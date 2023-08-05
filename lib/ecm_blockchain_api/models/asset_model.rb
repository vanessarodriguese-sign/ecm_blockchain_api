require 'active_model'

module ECMBlockchain
  class AssetModel
    include ActiveModel::Validations

    attr_accessor :uuid, :txId, :groupId, :title, :summary, :createdBy,
                  :file, :content, :created_at, :access, :lastInteraction, :events

    validates :uuid, :title, :summary, presence: true
    validate :data_file_or_content?
    validate :file_correct?
 
    class << self
      def verify(data={})
        asset = self.new(data)
        raise ECMBlockchain::UnprocessableEntityError.new(
          asset.errors.full_messages.first, 422
        ) unless asset.valid?
        nil
      end
    end

    def initialize(data={})
      @uuid = data.fetch(:uuid)
      @txId = data[:txId]
      @groupId = data[:groupId]
      @title = data.fetch(:title)
      @summary = data.fetch(:summary)
      @createdBy = data[:createdBy]
      @file = ECMBlockchain::DataFile.new(data[:file])
      @content = ECMBlockchain::DataContent.new(data[:content])
      @access = data.fetch(:access)
      @lastInteraction = data[:lastInteraction]
      @events = data[:events]
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

class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true
  has_one_attached :file

  before_create :set_slug

  private
    def set_slug
      self.slug = "#{basename}-#{SecureRandom.alphanumeric(6)}.#{extension}"
    end

    def basename
      File.basename(file.filename.to_s, ".*").parameterize
    end

    def extension
      File.extname(file.filename.to_s).delete(".").parameterize
    end
end

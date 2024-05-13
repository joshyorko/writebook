module Book::Publishable
  extend ActiveSupport::Concern

  included do
    after_save :generate_slug, if: -> { slug.blank? && just_published? }

    scope :published, -> { where.not(published_at: nil) }
    scope :not_published, -> { where(published_at: nil) }
  end

  def published?
    published_at.present?
  end

  def published=(value)
    value && value != "0" ? publish : unpublish
  end

  def publish
    update! published_at: Time.current
  end

  def unpublish
    update! published_at: nil
  end

  def public_url=(value)
    self.slug = value.split("/").last
  end

  def generate_slug
    update! slug: title.parameterize
  rescue ActiveRecord::RecordNotUnique
    update! slug: "#{title.parameterize}-#{SecureRandom.hex(4)}"
  end

  def just_published?
    saved_change_to_published_at? && published_at.present?
  end
end

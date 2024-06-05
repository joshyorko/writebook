class Book < ApplicationRecord
  include Accesses, Sluggable

  has_many :leaves, dependent: :destroy
  has_one_attached :cover

  scope :ordered, -> { order(:title) }
  scope :published, -> { where(published: true) }

  after_create :create_demo_leaves

  def press(leafable, leaf_params)
    transaction do
      leafable.save!
      leaves.create! leaf_params.merge(leafable: leafable)
    end
  end

  def create_demo_leaves
    image = File.open(Rails.root.join("app/assets/images/demo/inspiration-is-perishable.png"))
    picture = Picture.new(caption: "Inspiration is perishable")
    picture.image.attach(io: image, filename: "inspiration-is-perishable.png", content_type: "image/png")

    press Section.new(), title: "Chapter 1"
    press Page.new(body: "# Welcome to Writebook. \n\n Your new book begins here."), title: "My first page"
    press picture, title: "Figure 1"
  end
end

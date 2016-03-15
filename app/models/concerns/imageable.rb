module Imageable
  extend ActiveSupport::Concern
  included do
    has_many :images, as: :imageable, dependent: :nullify
    has_one :primary_image, -> { where(primary: true) },
                            as: :imageable, class_name: Image

    def primary_image
      super || Image.new
    end
  end
end

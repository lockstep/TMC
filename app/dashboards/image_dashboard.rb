require "administrate/base_dashboard"

class ImageDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    image: PaperclipField,
    product: Field::BelongsTo.with_options(class_name: "Product"),
    # imageable_id: Field::Number,
    # imageable_type: Field::Select.with_options(collection: ['Product', 'VisualExploration']),
    primary: Field::Boolean,
    caption: Field::String
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :image,
    :product,
    :caption,
    :primary
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :image,
    :product,
    :primary,
    :caption
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :image,
    :product,
    # :imageable_id,
    # :imageable_type,
    :primary,
    :caption
  ]

  # Overwrite this method to customize how products are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(image)
    "##{image.id} #{image.caption}"
  end
end

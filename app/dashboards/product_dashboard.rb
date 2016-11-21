require "administrate/base_dashboard"

class ProductDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    topics: Field::HasMany,
    presentation: Field::BelongsTo,
    images: Field::HasMany,
    downloadable: Field::HasOne,
    id: Field::Number,
    name: Field::String,
    price: Field::Number.with_options(
      prefix: "$",
      multiplier: 0.01,
      decimals: 1,
    ),
    featured: Field::Boolean,
    free: Field::Boolean,
    live: Field::Boolean,
    description: WysiwygField,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :topics,
    :featured,
    :downloadable,
    :images,
    :price
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :topics,
    :presentation,
    :images,
    :downloadable,
    :name,
    :price,
    :featured,
    :free,
    :description,
    :created_at,
    :updated_at,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :topics,
    :presentation,
    :images,
    :name,
    :price,
    :description,
    :featured,
    :free
  ]

  # Overwrite this method to customize how products are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(product)
    "##{product.id} #{product.name}"
  end
end

require "administrate/base_dashboard"

class ProductDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    presentation: Field::BelongsTo,
    images: Field::HasMany,
    downloadable: Field::HasOne,
    id: Field::Number,
    name: Field::String,
    price: Field::Number.with_options(
      title: "Order Total",
      prefix: "$",
      multiplier: 0.01,
      decimals: 1,
    ),
    featured: Field::Boolean,
    description: Field::Text,
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
    :presentation,
    :featured,
    :downloadable,
    :images,
    :price
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :presentation,
    :images,
    :downloadable,
    :name,
    :price,
    :featured,
    :description,
    :created_at,
    :updated_at,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :presentation,
    :images,
    :name,
    :price,
    :description,
    :featured
  ]

  # Overwrite this method to customize how products are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(product)
    "##{product.id} #{product.name}"
  end
end

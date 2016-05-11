require "administrate/base_dashboard"

class OrderDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    user: Field::BelongsTo,
    state: Enum,
    total_price: Field::Number.with_options(
      title: "Order Total",
      prefix: "$",
      multiplier: 0.01,
      decimals: 1,
    ),
    products: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  COLLECTION_ATTRIBUTES = [
    :id,
    :user,
    :total_price,
    :state,
    :created_at,
    :updated_at
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :user,
    :products,
    :total_price,
    :created_at,
    :updated_at
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :state
  ]

  # Overwrite this method to customize how products are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(order)
    "Order ##{order.id}"
  end
end

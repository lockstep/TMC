require "administrate/base_dashboard"

class OrderDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    user: Field::BelongsTo,
    state: Enum,
    item_total: Field::Number.with_options(
      prefix: "$",
      multiplier: 0.01,
      decimals: 1
    ),
    adjustment_total: Field::Number.with_options(
      prefix: "$",
      multiplier: 0.01,
      decimals: 1
    ),
    total: Field::Number.with_options(
      prefix: "$",
      multiplier: 0.01,
      decimals: 1
    ),
    promotion_code: Field::String,
    # make sure all of the line items are shown on order show page
    products: Field::HasMany.with_options(limit: 80),
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  COLLECTION_ATTRIBUTES = [
    :id,
    :user,
    :item_total,
    :state,
    :created_at,
    :updated_at
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :user,
    :state,
    :products,
    :item_total,
    :promotion_code,
    :adjustment_total,
    :total,
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

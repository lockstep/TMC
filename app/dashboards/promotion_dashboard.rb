require "administrate/base_dashboard"

class PromotionDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    code: Field::String,
    description: Field::String,
    percent: Field::Number,
    starts_at: Field::DateTime,
    expires_at: Field::DateTime
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  COLLECTION_ATTRIBUTES = [
    :code,
    :description,
    :percent,
    :starts_at,
    :expires_at
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :code,
    :description,
    :percent,
    :starts_at,
    :expires_at
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :code,
    :description,
    :percent,
    :starts_at,
    :expires_at
  ]

  # Overwrite this method to customize how products are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(promotion)
    "#{promotion.code} #{promotion.percent}%"
  end
end

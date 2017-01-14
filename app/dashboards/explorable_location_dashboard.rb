require "administrate/base_dashboard"

class ExplorableLocationDashboard < Administrate::BaseDashboard

  ATTRIBUTE_TYPES = {
    id: Field::Number,
    label: Field::String,
    x: Field::Number,
    y: Field::Number,
    visual_exploration: Field::BelongsTo,
    explorable: Field::Polymorphic,
    explorable_type: Field::Select.with_options(
      collection: [ 'Topic', 'Product' ]
    ),
    explorable_id: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }

  COLLECTION_ATTRIBUTES = [
    :id,
    :label,
    :visual_exploration
  ]

  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :label,
    :visual_exploration,
    :explorable,
    :x,
    :y
  ]

  FORM_ATTRIBUTES = [
    :label,
    :visual_exploration,
    :explorable_type,
    :explorable_id,
    :x,
    :y
  ]

end

require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    role: Enum,
    email: Field::String,
    orders: Field::HasMany,
    encrypted_password: Field::String,
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime,
    remember_created_at: Field::DateTime,
    sign_in_count: Field::Number,
    current_sign_in_at: Field::DateTime,
    last_sign_in_at: Field::DateTime,
    current_sign_in_ip: Field::String.with_options(searchable: false),
    last_sign_in_ip: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    password: Field::String,
    password_confirmation: Field::String
  }

  COLLECTION_ATTRIBUTES = [
    :id,
    :email,
    :orders,
    :role
  ]

  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :role,
    :email,
    :orders,
    :sign_in_count,
    :last_sign_in_at,
    :created_at
  ]

  FORM_ATTRIBUTES = [
    :email,
    :role,
    :password,
    :password_confirmation
  ]
end

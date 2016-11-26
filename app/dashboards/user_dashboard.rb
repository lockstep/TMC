require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    role: Enum,
    email: Field::String,
    bio: WysiwygField,
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
    password_confirmation: Field::String,
    address_line_one: Field::String,
    address_line_two: Field::String,
    address_city: Field::String,
    address_state: Field::String,
    address_postal_code: Field::String,
    address_country: Field::String,
    avatar: PaperclipField
  }

  COLLECTION_ATTRIBUTES = [
    :id,
    :email,
    :orders,
    :role
  ]

  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :first_name,
    :last_name,
    :avatar,
    :bio,
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
    :first_name,
    :last_name,
    :avatar,
    :bio,
    :password,
    :password_confirmation,
    :address_line_one,
    :address_line_two,
    :address_city,
    :address_state,
    :address_postal_code,
    :address_country
  ]

  def display_resource(user)
    user.last_name ? user.full_name : "User ##{user.id}"
  end
end

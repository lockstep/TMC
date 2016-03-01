require "administrate/fields/base"

class Enum < Administrate::Field::Number
  def to_s
    data
  end
end

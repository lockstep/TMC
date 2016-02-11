require "administrate/fields/base"

class WysiwygField < Administrate::Field::Text
  def to_s
    data.to_s
  end
end

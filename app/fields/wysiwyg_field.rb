require "administrate/field/base"

class WysiwygField < Administrate::Field::Text
  def self.searchable?
    true
  end

  def to_s
    data.to_s
  end
end

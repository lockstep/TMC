require "administrate/field/base"

class PaperclipField < Administrate::Field::Base
  def url
    data.url
  end

  def thumb
    data.url(:thumb)
  end

  def medium
    data.url(:medium)
  end

  def to_s
    data
  end
end

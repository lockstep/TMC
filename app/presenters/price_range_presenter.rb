class PriceRangePresenter
  def initialize(products:, range_params:, view:)
    @view = view
    @products = products
    @range_params = range_params
  end

  attr_accessor :view
  delegate :text_field_tag, to: :view

  # returns a text field that is used by JS to generate the slider
  # values order is: min;from;to;max
  def field
    text_field_tag :price_range, "#{minimum};#{@range_params};#{maximum}",
      id: "price-range", class: "form-control"
  end

  def minimum
    @products.map(&:price).min || 0
  end

  def maximum
    @products.map(&:price).max || 20
  end
end

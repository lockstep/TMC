module ProductsHelper
  def is_in_cart?(order, product)
    order.line_items.any? { |item| item.product_id == product.id }
  end
end

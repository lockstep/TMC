module Orders::CartHelper
  def add_to_cart(product = @product, shipping_cost_cents = nil)
    form_for LineItem.new do |f|
      f.hidden_field(:product_id, value: product.id).concat(
        f.hidden_field(:shipping_cost_cents, value: shipping_cost_cents)
      ).concat(
        f.submit 'Add to Cart', class: 'btn btn-cart',
          id: "add-product-#{product.id}",
          data: {
            id: product.id,
            name: product.name,
            value: product.price
          }
      )
    end
  end
end

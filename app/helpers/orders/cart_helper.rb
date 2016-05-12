module Orders::CartHelper
  def add_to_cart(product = @product)
    form_for [@order, LineItem.new] do |f|
      f.hidden_field(:product_id, value: product.id).concat(
        f.submit 'Add to Cart', class: 'btn btn-cart',
          id: "add-product-#{product.id}"
      )
    end
  end
end

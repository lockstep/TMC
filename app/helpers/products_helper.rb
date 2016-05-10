module ProductsHelper
  include SocialsHelper::ShareButtons

  SORT_OPTONS = [
    { name: 'Date: oldest first', value: 'created_at:asc' },
    { name: 'Date: newest first', value: 'created_at:desc' },
    { name: 'Price: lowest first', value: 'price:asc' },
    { name: 'Price: highest first', value: 'price:desc' }
  ]

  def is_in_cart?(order, product)
    order.line_items.any? { |item| item.product_id == product.id }
  end

  def sort_select
    select_tag :sort,
      options_for_select(
        SORT_OPTONS.collect{ |o| [o[:name], o[:value]] },
        @sort_by
      ), prompt: 'Please select'
  end
end

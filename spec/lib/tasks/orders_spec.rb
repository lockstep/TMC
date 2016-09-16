describe 'orders:remove_empty' do
  fixtures :orders
  fixtures :line_items

  include_context 'rake'

  it 'removes orders with no line items, keeps the rest' do
    one_line_item = orders(:cards_order)
    two_line_items = orders(:cards_order_completed)
    empty_order_1 = orders(:paid_animal_cards_order)
    empty_order_2 = orders(:no_line_items)
    task.invoke
    expect(Order.all).not_to include empty_order_1
    expect(Order.all).not_to include empty_order_2
    expect(Order.all).to include one_line_item
    expect(Order.all).to include two_line_items
  end
end

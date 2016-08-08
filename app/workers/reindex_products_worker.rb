class ReindexProductsWorker
  include Sidekiq::Worker

  def perform(product_ids)
    product_ids.each do |id|
      product = Product.find(id)
      product.reindex
    end
  end
end

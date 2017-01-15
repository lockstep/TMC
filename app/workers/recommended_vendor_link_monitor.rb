class RecommendedVendorLinkMonitor
  include Sidekiq::Worker

  def perform
    products_with_links_query = <<-SQL
      recommended_vendor_url IS NOT NULL OR
      recommended_budget_vendor_url IS NOT NULL
    SQL
    Product.where(products_with_links_query).find_each do |product|
      begin
        check_url(product.recommended_vendor_url)
        check_url(product.recommended_budget_vendor_url)
        check_url(product.external_resource_url)
      rescue => e
        send_notification(product, e)
      end
    end
  end

  private

  def check_url(url)
    return if url.blank?
    res = Net::HTTP.get(URI(url))
    raise "Bad Link" if res.to_i >= 400
  end

  def send_notification(product, _exception)
    UsersMailer.bad_link(product).deliver_now
  end
end

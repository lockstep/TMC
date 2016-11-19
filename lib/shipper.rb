module Shipper
  Rate = Struct.new(:service_name, :price_cents)

  def self.get_lowest_cost(recipient, product)
    origin = product.active_shipping_location
    destination = recipient.active_shipping_location
    if product.seller_mandated_shipping_cost?
      return shippers_minimum_rate(product)
    end
    packages = [ActiveShipping::Package.new(
      product.weight, # grams
      product.dimensions # cm
    )]
    lowest_rate = rates_sorted_by_price(origin, destination, packages)[0]
    determine_best_shipping_option(lowest_rate, product)
  end

  def self.determine_best_shipping_option(lowest_rate, product)
    if lowest_rate
      if lowest_rate.price_cents > product.max_shipping_cost_cents
        Rate.new('SHIPPER PREFERENCE', product.max_shipping_cost_cents)
      elsif lowest_rate.price_cents < product.min_shipping_cost_cents
        shippers_minimum_rate(product)
      else
        lowest_rate
      end
    else
      shippers_minimum_rate(product)
    end
  end

  def self.shippers_minimum_rate(product)
    Rate.new('SHIPPER PREFERENCE', product.min_shipping_cost_cents)
  end

  def self.rates_sorted_by_price(origin, destination, packages)
    # ups_rates  = ups.find_rates(origin, destination, packages).rates
    usps_rates = usps.find_rates(origin, destination, packages).rates
    (
      usps_rates # + ups_rates
    ).sort_by(&:price).collect do |rate|
      Rate.new(rate.service_name, rate.price)
    end
  end

  def self.ups
    ActiveShipping::UPS.new(
      login: ENV['UPS_USER_ID'],
      password: ENV['UPS_PASSWORD'],
      key: ENV['UPS_KEY']
    )
  end

  def self.usps
    ActiveShipping::USPS.new(login: ENV['USPS_USERNAME'])
  end

end

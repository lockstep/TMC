# Set the host name for URL creation
protocol = Rails.env.production? ? 'https' : 'http'
SitemapGenerator::Sitemap.default_host = "#{protocol}://www.#{ENV['HOST_NAME']}"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter =
  SitemapGenerator::S3Adapter.new(
    fog_provider: 'AWS',
    aws_access_key_id: ENV['S3_KEY'],
    aws_secret_access_key: ENV['S3_SECRET'],
    fog_directory: 'lockstep-sitemaps',
    fog_region: 'us-east-1'
  )
SitemapGenerator::Sitemap.sitemaps_host =
  "http://lockstep-sitemaps.s3-website-us-east-1.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'tmc/'

SitemapGenerator::Sitemap.create do
  # products
  add products_path, priority: 0.8, changefreq: 'daily'
  Product.find_each do |product|
    next unless product.downloadable
    add product_path(product), lastmod: product.updated_at, priority: 0.8,
      changefreq: 'daily',
      images: product.images.map { |i| { loc: i.url(:medium) } }
  end

  # posts
  add posts_path, priority: 0.7, changefreq: 'weekly'
  Post.find_each do |post|
    add post_path(post), lastmod: post.updated_at, priority: 0.8
  end

  # pages
  add page_path(:about), priority: 0.6, changefreq: 'weekly'
end

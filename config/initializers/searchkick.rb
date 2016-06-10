require 'typhoeus/adapters/faraday'

Searchkick.client = Elasticsearch::Client.new(
  url: ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200',
  retry_on_failure: true,
)


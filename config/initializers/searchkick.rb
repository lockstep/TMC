require 'typhoeus/adapters/faraday'

Searchkick.client = Elasticsearch::Client.new(
  hosts: [
    ENV['ELASTICSEARCH_HOST'] || 'localhost:9200'
  ],
  retry_on_failure: true,
)


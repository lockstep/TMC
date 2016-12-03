namespace :products do
  desc 'Monitor for bad links'
  task monitor_links: :environment do
    RecommendedVendorLinkMonitor.perform_async
  end
end

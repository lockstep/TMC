class Rack::Attack
  spammer_ips = [
    '162.211.152.253'
  ]
  # Turn spammers array into a regexp
  spammer_regexp = Regexp.union(spammer_ips)
  blacklist("Block Spam IPs") do |request|
    request.ip =~ spammer_regexp
  end
end

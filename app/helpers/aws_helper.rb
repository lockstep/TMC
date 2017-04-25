module AwsHelper
  def s3_auth(filename, content_type = nil)
    key = "images/#{SecureRandom.uuid}-#{filename}"
    {
      credentials: {
        key: key, policy: s3_policy(content_type),
        signature: s3_signature(content_type),
        AWSAccessKeyId: ENV['S3_KEY'], acl: 'public-read',
        endpoint: ENV['S3_BUCKET_ENDPOINT']
      }
    }
  end

  private

  def s3_signature(content_type)
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest.new('sha1'),
        ENV['S3_SECRET'],
        s3_policy(content_type)
      )
    ).delete("\n")
  end

  def s3_policy(content_type)
    Base64.encode64(s3_policy_data(content_type).to_json)
      .gsub("\n", "")
  end

  def s3_policy_data(content_type)
    {
      expiration: 30.minutes.from_now.utc.iso8601,
      conditions: [
        [ "starts-with", "$key", "images/" ],
        [ "starts-with", "$Content-Type", content_type || ""],
        [ "content-length-range", 1, 10485760 ],
        { bucket: ENV['S3_BUCKET'] },
        { acl: 'public-read' }
      ]
    }
  end

end

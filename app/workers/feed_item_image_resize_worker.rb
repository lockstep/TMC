class FeedItemImageResizeWorker
  include Sidekiq::Worker

  def perform(feed_item_id)
    feed_item = FeedItem.find(feed_item_id)
    return if feed_item.raw_image_s3_key.blank?
    file_path = download_s3_file(feed_item.raw_image_s3_key)
    return unless file_path.present?
    if feed_item.update(image: file_path.open)
      File.delete(file_path)
      delete_s3_file(feed_item.raw_image_s3_key)
      feed_item.update(raw_image_s3_key: nil)
    end
  end

  private

  def download_s3_file(s3_key)
    return unless s3_key.present?
    s3 = AWS::S3.new
    file_name = "#{s3_key.split('/').last}"
    file_dir = Rails.root.join('tmp', 'images')
    Dir.mkdir(file_dir) unless Dir.exist?(file_dir)
    file_path = file_dir + file_name
    File.open(file_path, 'wb') do |file|
      object = s3.buckets[ENV['S3_BUCKET']].objects[s3_key]
      return unless object.exists?
      object.read do |chunk|
        file.write(chunk)
      end
    end
    file_path
  end

  def delete_s3_file(s3_key)
    return unless s3_key.present?
    s3 = AWS::S3.new
    object = s3.buckets[ENV['S3_BUCKET']].objects[s3_key]
    object.delete
  end

end

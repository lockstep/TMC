module Admin
  class PostsController < Admin::ApplicationController
    before_action :set_s3_direct_post, only: [:new, :edit]

    private

    def set_s3_direct_post
      @s3_direct_post = S3_BUCKET.presigned_post(
        key: "blog/#{SecureRandom.uuid}_${filename}",
        success_action_status: '201',
        acl: 'public-read'
      ).where(:content_type).starts_with("image/")
    end
  end
end

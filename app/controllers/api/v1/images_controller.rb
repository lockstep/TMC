class Api::V1::ImagesController < Api::V1::BaseController
  include FeedItems

  def index
    page_num = params[:page] || 1
    conference = Conference.find(params[:conference_id])
    images = conference.images.order(:created_at).page(page_num).per(15)
    render json: images,
      each_serializer: CommentSerializer, root: 'images',
      meta: {
        current_page: page_num,
        per_page: 15,
        total_pages: images.total_pages
      }
  end

  def create
    feedable = Conference.find(params[:conference_id])
    image = FeedItems::Image.new(
      feedable: feedable,
      raw_image_s3_key: feed_item_params[:raw_image_s3_key],
      author: current_user
    )
    if image.save
      FeedItemImageResizeWorker.perform_async(image.id)
      render json: image, root: 'image', serializer: CommentSerializer
    else
      render json: { meta: { errors: image.errors }},
        status: :unprocessable_entity
    end
  end
end

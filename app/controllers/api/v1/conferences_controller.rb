class Api::V1::ConferencesController < Api::V1::BaseController
  include FeedItems

  def show
    conference = Conference.find(params[:id])
    render json: conference
  end

  def save_image
    feedable = Conference.find(params[:id])
    image = FeedItems::Image.new(
      feedable: feedable,
      raw_image_s3_key: feed_item_params[:raw_image_s3_key],
      author: current_user
    )
    if image.save
      FeedItemImageResizeWorker.perform_async(image.id)
      render json: image, root: 'image', serializer: ImageSerializer
    else
      render json: { meta: { errors: image.errors }},
        status: :unprocessable_entity
    end
  end

  def images
    page_num = params[:page] || 1
    conference = Conference.find(params[:id])
    images = conference.images.page(page_num).per(15)
    render json: images,
      each_serializer: ImageSerializer, root: 'images',
      meta: {
        current_page: page_num,
        per_page: 15,
        total_pages: images.total_pages
      }
  end
end

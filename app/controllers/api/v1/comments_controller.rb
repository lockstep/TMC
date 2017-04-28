class Api::V1::CommentsController < Api::V1::BaseController
  include FeedItems
  before_action :set_breakout_session, only: [:index, :create]

  def create
    comment = FeedItems::Comment.new(
      feedable: @breakout_session,
      message: feed_item_params[:message],
      raw_image_s3_key: feed_item_params[:raw_image_s3_key],
      author: current_user
    )
    if comment.save
      FeedItemImageResizeWorker.perform_async(comment.id)
      return head :created
    else
      render json: { meta: { errors: comment.errors }},
        status: :unprocessable_entity
    end
  end

  def index
    page_num = params[:page] || 1
    comments = @breakout_session.comments.page(page_num).per(15)
    render json: comments,
      each_serializer: CommentSerializer, root: 'comments',
      meta: {
        current_page: page_num,
        per_page: 15,
        total_pages: comments.total_pages
      }
  end

  private

  def set_breakout_session
    @breakout_session = BreakoutSession.find(params[:breakout_session_id])
  end
end

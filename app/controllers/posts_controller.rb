class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page] || 1).per(10)
  end

  def show
  end

  private

  def set_post
    @post = Post.friendly.find(params[:id])

    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    if request.path != post_path(@post)
      return redirect_to @post, :status => :moved_permanently
    end
  end
end

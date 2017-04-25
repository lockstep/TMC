class Api::V1::AwsS3AuthsController < Api::V1::BaseController
  include AwsHelper

  before_filter :authenticate_user!

  def show
    render json: s3_auth(params[:filename], params[:content_type])
  end
end

class Api::V1::AwsServicesController < Api::V1::BaseController
  include AwsHelper

  before_filter :authenticate_user!

  def aws_s3_auth
    render json: s3_auth(params[:filename], params[:content_type])
  end
end

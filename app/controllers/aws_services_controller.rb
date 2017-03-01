class AwsServicesController < ApplicationController
  include AwsHelper

  def aws_s3_auth
    render json: s3_auth(params[:filename], params[:content_type])
  end
end

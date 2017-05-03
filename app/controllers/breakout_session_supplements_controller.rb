class BreakoutSessionSupplementsController < ApplicationController
  before_action :authenticate_user!

  def create
    breakout_session = BreakoutSession.find(params[:breakout_session_id])
    authorize_user(breakout_session)
    supplement = breakout_session.breakout_session_supplements.new(
      breakout_session_supplement_params
    )
    if supplement.save
      redirect_to :back, notice: 'Document added!'
    else
      redirect_to :back,
        alert: "Oops, we don't support that file type. Please try with a different format or contact support with the link at the bottom of the page."
    end
  rescue ActionController::ParameterMissing
    redirect_to :back, alert: 'You must select a file to upload.'
  end

  def destroy
    breakout_session_supplement = BreakoutSessionSupplement.find(params[:id])
    authorize_user(breakout_session_supplement.breakout_session)
    breakout_session_supplement.destroy
    redirect_to :back, notice: 'File removed'
  end

  private

  def authorize_user(breakout_session)
    raise 'Unauthorized' if !breakout_session.organizers.include?(current_user)
  end

  def breakout_session_supplement_params
    params.require(:breakout_session_supplement).permit(:document)
  end
end

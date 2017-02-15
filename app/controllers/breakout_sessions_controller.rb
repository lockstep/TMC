class BreakoutSessionsController < ApplicationController
  before_action :set_session, only: [:show, :join_session, :comment]

  def comment
    return unless current_user
    return if params[:message].blank?
    @breakout_session.comments.create(user: current_user,
                                      message: params[:message])
  end

  def join_session
    return unless current_user
    return if @breakout_session.attendees.find_by(id: current_user.id)
    @breakout_session.attendees << current_user
    @breakout_session.save
  end

  private

  def set_session
    @breakout_session = BreakoutSession
      .find(params[:breakout_session_id] || params[:id])
  end
end

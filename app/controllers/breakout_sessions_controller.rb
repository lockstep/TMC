class BreakoutSessionsController < ApplicationController
  before_action :set_breakout_session, only: [:show, :join_session]

  def show
    store_location_for(:user, breakout_session_conference_path(
      @breakout_session.conference, @breakout_session))
    @comments = @breakout_session.breakout_session_comments
      .order(created_at: :desc)
      .page(params[:page] || 1)
      .per(15)
  end

  def join_session
    authenticate_user!
    if @breakout_session.attendees.find_by(id: current_user.id)
      redirect_to :back, alert: t('.already_joined')
      return
    end
    unless current_user.opted_in_to_public_directory?
      redirect_to :back, alert: t('.profile_must_be_listed_in_the_directory')
      return
    end
    @breakout_session.attendees << current_user
    @breakout_session.save
    redirect_to :back, notice: t('.joined_session')
  end

  private

  def set_breakout_session
    @breakout_session = BreakoutSession.find(
      params[:breakout_session_id] || params[:id])
  end
end

class BreakoutSessionsController < ApplicationController
  before_action :set_breakout_session, only: [:show, :join_session]

  def new
    if current_user && OrganizedBreakoutSession.pluck(:user_id).include?(current_user.id)
      redirect_to directory_path, notice: t('breakout_sessions.errors.already_applied')
    else
      conference = Conference.find(params[:id])
      @breakout_session = BreakoutSession.new(conference: conference)
      @timeslots = @breakout_session.breakout_session_timeslots.
        order(:day, :start_time).available
    end
  end

  def create
    authenticate_user!
    conference = Conference.find(params[:id])
    @timeslot = BreakoutSessionLocationTimeslot.find(
      params[:breakout_session][:breakout_session_location_timeslot]
    )
    @breakout_session = BreakoutSession.new(breakout_session_params)
    @breakout_session.conference = conference
    @breakout_session.organizers << current_user
    if @breakout_session.save
      @timeslot.update!(breakout_session: @breakout_session)
      UsersMailer.new_breakout_session_application(@breakout_session.id)
        .deliver_later
      redirect_to directory_path, notice: t('.thank_you')
    else
      @timeslots = @breakout_session.breakout_session_timeslots.
        order(:day, :start_time).available
      flash.now[:error] = 'Please complete all fields.'
      render :new
    end
  end

  def show
    store_location_for(:user, breakout_session_path(@breakout_session))
    @comments = @breakout_session.comments
      .order(created_at: :desc)
      .page(params[:page] || 1)
      .per(15)
    respond_to do |format|
      format.html
      format.json do
        render json: @breakout_session, root: 'breakout_session',
          each_serializer: BreakoutSessionSerializer, comments: @comments
      end
    end
  end

  def join_session
    authenticate_user!
    if @breakout_session.attendees.find_by(id: current_user.id)
      redirect_to :back, alert: t('.already_joined')
      return
    end
    unless current_user.opted_in_to_public_directory?
      redirect_to :back, alert: t(
        '.profile_must_be_listed_in_the_directory',
        directory_path: directory_path
      )
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

  def breakout_session_params
    params.require(:breakout_session).permit(
      :name, :description
    )
  end
end

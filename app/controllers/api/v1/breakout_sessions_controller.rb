module Api
  module V1
    class BreakoutSessionsController < BaseController
      before_filter :authenticate_user!
      before_action :set_breakout_session, :approved_breakout_session?,
        only: [:show]
      
      def index
        breakout_sessions = Conference.find(params[:id])
          .breakout_sessions.approved
        render json: breakout_sessions
      end

      def show
        render json: @breakout_session
      end

      private

      def set_breakout_session
        @breakout_session ||= BreakoutSession.find(params[:id])
      end

      def approved_breakout_session?
        render json: { 
          meta: { errors: { message: [ 'resource not found' ] } } 
        }, status: :not_found unless @breakout_session.approved
      end

    end
  end
end

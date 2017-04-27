module Api
  module V1
    class BreakoutSessionsController < BaseController
      before_filter :authenticate_user!
      before_action :set_breakout_session,
        :require_approved_breakout_session, only: [:show]

      def index
        breakout_sessions = BreakoutSession.where(
          conference_id: find_conference_id
        ).approved
        render json: breakout_sessions
      end

      def show
        render json: @breakout_session
      end

      private

      def set_breakout_session
        @breakout_session ||= BreakoutSession.find(params[:id])
      end

      def require_approved_breakout_session
        unless @breakout_session.approved
          render json: {
            meta: { errors: { message: [ 'resource not found' ] } }
          }, status: :not_found
        end
      end

      def find_conference_id
        params[:id] ||
        Conference.find_or_create_by(
          name: 'International Montessori Congress',
          location: "Prague, Czech Republic"
        ).id
      end
    end
  end
end

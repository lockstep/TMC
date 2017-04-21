module Api
  module V1
    class BreakoutSessionsController < BaseController
      before_filter :authenticate_user!
      
      def index
        breakout_sessions = Conference.find(params[:id]).breakout_sessions
        render json: breakout_sessions
      end

    end
  end
end

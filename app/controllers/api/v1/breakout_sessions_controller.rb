module Api
  module V1
    class BreakoutSessionsController < BaseController
      before_filter :authenticate_user!
      
      def index
        page_num = params[:page] || 1
        breakout_sessions = Conference.find(params[:id]).breakout_sessions
          .page(page_num).per(15)
        render json: breakout_sessions,
          meta: {
            current_page: page_num,
            per_page: 15,
            total_pages: breakout_sessions.total_pages
          }
      end

    end
  end
end

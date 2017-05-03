module Admin
  class BreakoutSessionImportsController < Admin::ApplicationController

    def new
    end

    def create
      breakout_session_import = BreakoutSessionImport.new(import_params)
      breakout_session_import.import!
      redirect_to breakout_session_import.conference
    end

    private

    def import_params
      params.require(:admin_breakout_session_import).permit(
        :conference_id, :import_file
      )
    end

  end
end

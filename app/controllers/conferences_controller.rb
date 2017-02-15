class ConferencesController < ApplicationController
  before_action :set_conference, only: [:show]

  private

  def set_conference
    @conference = Conference.find(params[:id])
  end
end

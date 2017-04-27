class BreakoutSessionSerializer < ActiveModel::Serializer
  include ConferencesHelper
  
  attributes :id, :name, :description, :day, :start_time, :end_time,
    :location_name
  has_many :organized_breakout_sessions, serializer: OrganizerSerializer,
    key: :organizers

  def day
    format_date(object)
  end

  def start_time
    format_time(object.start_time)
  end

  def end_time
    format_time(object.end_time)
  end

  def location_name
    format_location(object)
  end
end

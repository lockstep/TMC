class BreakoutSessionSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :day, :start_time, :end_time,
    :approved, :location_name
  has_many :organized_breakout_sessions, serializer: OrganizerSerializer,
    key: :organizers

end

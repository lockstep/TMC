class BreakoutSessionSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :comments, serializer: CommentSerializer

  def comments
    instance_options[:comments]
  end
end

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can [:show, :update], User, id: user.id
    can :show, Order, user_id: user.id
  end
end

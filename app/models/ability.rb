class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can [:show, :update], User, id: user.id
    can :show, Order
  end
end

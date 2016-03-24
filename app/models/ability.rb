class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can [:show, :update], User, id: user.id
    can :show, Order do |order|
      (!order.user || order.user == user) && !order.paid?
    end
  end
end

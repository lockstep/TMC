class Ability
  include CanCan::Ability

  def initialize(user, session)
    user ||= User.new
    can [:show, :update], User, id: user.id
    can :show, Order do |order|
      order.user == user || session[:order_id] == order.id
    end
  end
end

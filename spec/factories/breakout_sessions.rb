FactoryGirl.define do
  factory :breakout_session do
    name 'Teaching'
    day Date.today
    start_time '15:00'
    end_time '16:00'
    slug 'teaching'
  end
end

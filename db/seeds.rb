# create user
User.create_with(password: 'password')
  .find_or_create_by(email: 'user@email.com')

# generate topics
top_level_topics = ['Sensorial', 'Practical Life', 'Mathematics', 'Language']
sensorial_topics = ['Auditory Sense', 'Olfactory Sense', 'Gustatory Sense',
          'Stereognostic Sense', 'Visual Mixed Sense', 'Sensorial Extensions',
          'Tactile Sense', 'Visual Sense']

top_level_topics.each do |topic|
  Topic.find_or_create_by(name: topic)
end

sensorial_topic = Topic.find_or_create_by(name: 'Sensorial')

sensorial_topics.each do |topic|
  Topic.find_or_create_by(name: topic, parent: sensorial_topic)
end

Topic.find_or_create_by(name: 'Cylinder Blocks', parent: Topic.find_or_create_by(name: 'Visual Sense'))


# Create public directory entries

positions_mod = User::POSITIONS.size - 1
65.times do |i|
  email = Faker::Internet.email
  creating_with = {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    opted_in_to_public_directory: true,
    position: User::POSITIONS[i%positions_mod],
    organization_name: Faker::University.name,
    address_country: Faker::Address.country_code,
    avatar: Faker::LoremPixel.image,
    bio: Faker::Lorem.sentence,
    password: 'fakepassword'
  }
  pp 'Creating user in directory:'
  pp creating_with
  User.create_with(creating_with).find_or_create_by(email: email)
end

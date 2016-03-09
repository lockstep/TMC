# create user
user = User.new(email: 'user@email.com', password: 'password')
user.skip_confirmation!
user.save!

# generate topics
top_level_topics = ['Sensorial', 'Practical Life', 'Mathematics', 'Language']
sensorial_topics = ['Auditory Sense', 'Olfactory Sense', 'Gustatory Sense',
          'Stereognostic Sense', 'Visual Mixed Sense', 'Sensorial Extensions',
          'Tactile Sense', 'Visual Sense']

top_level_topics.each do |topic|
  Topic.create(name: topic)
end

sensorial_topic = Topic.find_by(name: 'Sensorial')

sensorial_topics.each do |topic|
  Topic.create(name: topic, parent: sensorial_topic)
end

Topic.create(name: 'Cylinder Blocks', parent: Topic.find_by(name: 'Visual Sense'))

# generate presentations
presentations = ['1 Block with Blindfold', '2 Blocks with Blindfold',
                 '3 Blocks with Blindfold', '4 Blocks with Blindfold',
                 'Block 1', 'Block 2', 'Block 3', 'Block 4',
                 '2 Blocks Together', '3 Blocks Together', '4 Blocks Together']

presentations.each do |presentation|
  Presentation.create(name: presentation, topic: Topic.last,
                      summary: 'Playing with blocks.',
                      description: 'Basic blocks exercises.')
end

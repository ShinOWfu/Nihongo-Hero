require 'json'

Question.destroy_all
Fight.destroy_all
StoryLevel.destroy_all
Enemy.destroy_all
User.destroy_all

# story creation for japanese questions and answers
puts 'Creating Japanese (N3) questions..'

file_path = Rails.root.join('db', 'seeds', 'jlpt_n3_questions.json')
questions_data = JSON.parse(File.read(file_path))

questions_data.each_with_index do |q_data, index|
  question = Question.create(
    question_type: q_data["type"],
    question: q_data["question"],
    answers: q_data["answers"],
    correct_index: q_data["correct_index"]
  )
  puts "Created Question #{index + 1}: #{question.question[0..10]}..."
end
puts "Created #{questions_data.length} N3 questions!"

# story creation for map levels
puts 'Creating stories...'
story_file_path = Rails.root.join('db', 'seeds', 'story_levels.json')
stories_data = JSON.parse(File.read(story_file_path))

stories_data.each do |story|
  StoryLevel.create(
    story_content: story["story_content"],
    map_image: story["map_image"],
    map_node: story["map_node"]
  )
end
puts "Created #{stories_data.length} Stories for your map levels!"

# enemies seeds
puts 'Generating enemies'
enemy_file_path = Rails.root.join('db', 'seeds', 'enemies.json')
enemies_data = JSON.parse(File.read(enemy_file_path))
enemies_data.each do |enemy|
  Enemy.create(
    name: enemy['name'],
    hitpoints: enemy['hitpoints'],
    sprite: enemy['sprite'],
    weakness: enemy['weakness'],
    strength: enemy['strength']
  )
end
puts 'Generated enemies!'

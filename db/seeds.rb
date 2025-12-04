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

# users seeds
puts 'Generating users'
user_file_path = Rails.root.join('db', 'seeds', 'users.json')
users_data = JSON.parse(File.read(user_file_path))
users_data.each do |user|
  User.create(
    email: user["email"],
    password: "123456",
    password_confirmation: "123456",
    character_name: user['character_name'],
    experience_points: user['experience_points'],
    level: user['level']
  )

end
puts 'Generated users!'
 # Update existing users with nil values
User.where(experience_points: nil).update_all(experience_points: 0)
User.where(level: nil).update_all(level: 0)
User.where(hitpoints: nil).update_all(hitpoints: 60)

# User for Pitch. Delete after pitch
user = User.create(
    email: "bob@user",
    password: "123456",
    password_confirmation: "123456",
    level: 5,
    experience_points: 580,
    character_name: "Bob",
  )

story_levels_array = StoryLevel.all  
for index in (1..8) do
  fight = Fight.create(
    user: user,
    story_level: story_levels_array.find{|story_level| story_level.map_node == index},
    status: "completed",
    enemy: Enemy.all.sample
  )
  FightQuestion.create(
    fight: fight,
    question: Question.all.sample,
    selected_index: rand(0..3)
  )
end
  #Bob2
  user = User.create(
    email: "bob@user2",
    password: "123456",
    password_confirmation: "123456",
    level: 5,
    experience_points: 580,
    character_name: "Bobby",
  )

story_levels_array = StoryLevel.all  
for index in (1..8) do
  fight = Fight.create(
    user: user,
    story_level: story_levels_array.find{|story_level| story_level.map_node == index},
    status: "completed",
    enemy: Enemy.all.sample
  )
  FightQuestion.create(
    fight: fight,
    question: Question.all.sample,
    selected_index: rand(0..3)
  )
end
  #Bob3
  user = User.create(
    email: "bob@user3",
    password: "123456",
    password_confirmation: "123456",
    level: 5,
    experience_points: 580,
    character_name: "Alice",
  )

story_levels_array = StoryLevel.all  
for index in (1..8) do
  fight = Fight.create(
    user: user,
    story_level: story_levels_array.find{|story_level| story_level.map_node == index},
    status: "completed",
    enemy: Enemy.all.sample
  )
  FightQuestion.create(
    fight: fight,
    question: Question.all.sample,
    selected_index: rand(0..3)
  )
end
  #Bob4
  user = User.create(
    email: "bob@user4",
    password: "123456",
    password_confirmation: "123456",
    level: 5,
    experience_points: 580,
    character_name: "Peter",
  )

story_levels_array = StoryLevel.all  
for index in (1..8) do
  fight = Fight.create(
    user: user,
    story_level: story_levels_array.find{|story_level| story_level.map_node == index},
    status: "completed",
    enemy: Enemy.all.sample
  )
  FightQuestion.create(
    fight: fight,
    question: Question.all.sample,
    selected_index: rand(0..3)
  )
end
  #Bob5
  user = User.create(
    email: "bob@user5",
    password: "123456",
    password_confirmation: "123456",
    level: 5,
    experience_points: 580,
    character_name: "Betty",
  )

story_levels_array = StoryLevel.all  
for index in (1..8) do
  fight = Fight.create(
    user: user,
    story_level: story_levels_array.find{|story_level| story_level.map_node == index},
    status: "completed",
    enemy: Enemy.all.sample
  )
  FightQuestion.create(
    fight: fight,
    question: Question.all.sample,
    selected_index: rand(0..3)
  )
end

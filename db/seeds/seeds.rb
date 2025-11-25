require 'json'

# story creation for japanese questions and answers
puts 'Creating Japanese (N3) questions..'

file_path = './jlpt_n3_questions.json'
questions_data = JSON.parse(File.read(file_path))

questions_data.each_with_index do |q_data, index|
  question = Question.create(
    type: q_data["type"],
    question: q_data["question"],
    answers: q_data["answers"],
    correct_index: q_data["correct_index"]
  )
  puts "Created Question #{index + 1}: #{question.question[0..10]}..."
end
puts "Created #{questions_array.length} N3 questions!"

# story creation for map levels
puts 'Creating stories...'
story_file_path = './map_stories.json'
stories_data = JSON.parse(File.read(story_file_path))

stories_data.each do |story|
  MapLevel.create(
    story_content: story["story_content"]
  )
end
puts "Created #{stories_data.length} Stories for your map levels!"

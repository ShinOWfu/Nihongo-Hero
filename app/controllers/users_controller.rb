class UsersController < ApplicationController
  def show
    @user = current_user
    # Calculate how many levels the user has completed
    @levels_cleared = @user.fights.where(status: "completed").last.pluck(:story_level_id)
    # Calculate the average percentage of correct answers
    all_count = @user.fight_questions.all.count
    correct_count = @user.fight_questions.joins(:question).where('fight_questions.selected_index = questions.correct_index').count
    @avg_perc_correct = correct_count.to_f/all_count * 100
    # Calculate the streak of how many days in a row the user has completed at least one level 
    @days_streak = streak
  end

  def streak
    unique_creation_dates = @user.fight_questions.pluck(:created_at).map(&:to_date).uniq.sort                                     
    # If there are no questions, the streak is 0
    return 0 if unique_creation_dates.empty?
      
    last_question_date = unique_creation_dates.last
      #If our last correct question was today or yesterday, we start the streak at 1
    
    # If last question is before yesterday, there is no streak
    if last_question_date < Date.yesterday
      return 0 
    end

    # Otherwise, we initialize our streak at 1 day
    current_streak = 1

    #Starting from the day before the last day of activity (-2, since arrays start at 0), we check if current day is exactly one day before the previous day
    (unique_creation_dates.length - 2).downto(0) do |i|
    current_date = unique_creation_dates[i]
    previous_date = unique_creation_dates[i+1]
    
    # Check if the current date is exactly one day before the next date (consecutive)
      if current_date == previous_date - 1.day
        current_streak += 1
      else
        # Sequence is broken. Stop and return the count.
        break
      end
    end
    
    return current_streak
  end

  def leaderboard
    @top_5_global = User.order(level: :desc).limit(5)
    @top_5_friends = current_user.friends.order(level: :desc).limit(5)
  end
end

#Add a friends table to the schema
#Create a form that lets you add other users as friends
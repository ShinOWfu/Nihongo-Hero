class UsersController < ApplicationController
  def show
    @user = current_user
    # Calculate how many levels the user has completed
    @levels_cleared = @user.fights.where(status: "completed").last&.story_level_id
    # Calculate the average percentage of correct answers
    all_count = @user.fight_questions.all.count
    correct_count = @user.fight_questions.joins(:question).where('fight_questions.selected_index = questions.correct_index').count
    @avg_perc_correct = (correct_count.to_f/all_count * 100).to_i
    # Calculate the streak of how many days in a row the user has completed at least one level
    @days_streak = streak
    #Leaderboard
    @top_5_global = User.order(level: :desc).limit(5)
    @top_5_friends = current_user.friends.order(level: :desc).limit(5)
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

  def add_friend
    # The identifier (character name) is passed directly via params from the form
    char_name = params[:identifier] 
    friend_user = User.find_by(character_name: char_name)

    # --- VALIDATIONS ---
    # User not found
    unless friend_user
      redirect_to request.referrer || root_path, alert: "User '#{char_name}' not found."
      return
    end

    # Cannot add self
    if friend_user == current_user
      redirect_to request.referrer || root_path, alert: "You cannot add yourself as a friend"
      return
    end

    # Check for existing friendship (outgoing or incoming)
    if current_user.friends.include?(friend_user)
      redirect_to request.referrer || root_path, alert: "#{friend_user.character_name} is already connected with you."
      return
    end
    # --- END VALIDATIONS ---
    
    # 2. Create the new friendship (current_user is the initiator)
    # This uses the 'friendships' association defined in the User model.
    @friendship = Friendship.new(user_id: current_user.id, friend_user_id: friend_user.id )

    # Successful Path: Redirects back to the page the form was submitted from
    if @friendship.save
      redirect_to request.referrer || root_path, notice: "You are now friends with #{friend_user.character_name}!"
    else
      # Failure Path: Redirects back to the page the form was submitted from
      redirect_to request.referrer || root_path, alert: "Failed to add friend: #{@friendship.errors.full_messages.to_sentence}"
    end
  end

end

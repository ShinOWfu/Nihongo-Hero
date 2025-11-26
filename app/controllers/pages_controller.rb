class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if user_signed_in?
      redirect_to map_path
    else
      redirect_to new_user_session_path
    end
  end
end

class ProfilesController < ApplicationController
  before_action :authenticate_user
  before_action :restrict_access, only: [:edit, :show]
  before_action :set_user, :set_profile, only: [:show, :edit, :update, :destroy]

  def index
    @profile = Profile.all
  end

  def show
		@user = User.find(current_user.id)
		@profile = Profile.find_by(user_id: current_user.id)
    @meal = @profile.school.school_meals.find_by(date: Date.tomorrow)
  end

  def edit
    @preferences = Preference.all
    @schools = School.all
    @user_school = School.all.find_by(school_code: current_user.school_code)
  end

  def update
    @profile.update(profile_parameters)
  end

  private

  def set_user # keeping it dry !
    @user = current_user
  end

  def set_profile
    @profile = Profile.find_by(user_id: current_user.id)
  end

  def profile_parameters
    params.require(:profile).permit(:school_id,
      preference_ids: []
    )
  end

  def school_parameters
    params.require(:profile).permit(:school_id)
  end

  def authenticate_user
    unless current_user || current_admin
      redirect_to root_path, notice: "Veuillez vous connecter pour accéder à vos informations."
    end
  end

  def restrict_access
    @profile = Profile.find_by(user_id: current_user.id)
    if @profile.id != current_user.profile.id
      redirect_to root_path, notice: "Vous n'avez pas accès à ces informations."
    end
  end

end

class ProfilesController < ApplicationController
	before_action :authenticate_user
	before_action :restrict_access, only: [:edit, :show]

  def index
    @profile = Profile.all
  end

  def show
		@user = User.find(current_user.id)
		@profile = Profile.find_by(user_id: current_user.id)
  end

  def edit
    @user = User.find(params[:user_id])
    @profile = Profile.find(params[:id])
    @preferences = Preference.all
  end


  def update
		@profile = Profile.find_by(user_id: current_user.id)
		@profile.update(profile_parameters)
  end

	private

  def profile_parameters
		params.require(:profile).permit(
			preference_ids: []
		)
  end

 def authenticate_user
    unless current_user
      redirect_to root_path, :notice => "Veuillez vous connecter pour accéder à vos informations."
    end
  end

  def restrict_access
  	@profile = Profile.find(params[:id])
  	user = current_user.id
  if @profile.id != current_user.profile.id
  	redirect_to root_path, :notice => "Vous n'avez pas accès à ces informations."
  end
  end

end

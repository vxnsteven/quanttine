class User < ApplicationRecord
	has_one :profile, dependent: :destroy
	# after_create :welcome_send
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  after_create :create_profile

	validates :first_name, :last_name,
  presence: true,
	length: { in: 2..50 }

  validates :school_code,
  presence: true

  private

  def create_profile
    Profile.create!(user_id: self.id, school_id: School.find_by(school_code: self.school_code).id)
  end

  def welcome_send
  	UserMailer.welcome_email(self).deliver_now
  end

  
  

end

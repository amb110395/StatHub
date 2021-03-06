# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  email                        :string(255)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  password_digest              :string(255)
#  remember_token               :string(255)
#  profile_picture_file_name    :string(255)
#  profile_picture_content_type :string(255)
#  profile_picture_file_size    :integer
#  profile_picture_updated_at   :datetime
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :birthday, :password, :password_confirmation, :profile_picture, :old_password
  has_secure_password

  #Virtual attribute used in the edit form when user wishes to change its password
  attr_accessor :old_password

  has_attached_file :profile_picture, :styles => { :medium => "170x170>" },
                    :default_url => ActionController::Base.helpers.asset_path('default_profile_picture.png'),
                    :convert_options => {:medium => "-gravity center -extent 170x170"}

  validates_attachment_size :profile_picture, :less_than => 3.megabytes
  validates_attachment_content_type :profile_picture, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg', 'image/jpg']

  has_many :sportizations
  has_many :sports, :through => :sportizations

  has_many :basketball_stats
  has_many :football_quarterback_stats
  has_many :football_receiver_stats
  has_many :football_runningback_stats
  has_many :football_defense_stats


  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name,  presence: true, length: { maximum: 30 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }, :on => "create"
  validates :password_confirmation, presence: true, :on => "create"
  validates :birthday, presence: true



  def self.search search_term

   search_term.present? and where(['name LIKE ?', "%#{search_term}%"])

  end

  def send_password_reset
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  private
    #Creates a random Base64 string that will be used as the remember token for the user
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end







end

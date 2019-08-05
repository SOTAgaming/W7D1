# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :password_digest, presence: true
  validates :session_token, uniqueness: true
  validates :password, length: { minimum: 3}, allow_nil: true
  
  after_initialize :ensure_session_token

  has_many :cats

  has_many :cat_rental_requests

  has_many :rental_requests,
  through: :cats,
  source: :rental_requests

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    self.session_token
  end 

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password) 
    @password = password
  end 

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end 

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil if user.nil?

    if user.is_password?(password)
      return user
    end 
    nil
  end 

end

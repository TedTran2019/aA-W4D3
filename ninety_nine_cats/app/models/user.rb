# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
	validates :username, :password_digest, :session_token, presence: true
	validates :username, :session_token, uniqueness: true
	validates :password, length: { minimum: 6, allow_nil: true }
	before_validation :ensure_session_token

	attr_reader :password

	has_many :cats,
	foreign_key: :owner_id

	has_many :cat_rental_requests,
	dependent: :destroy

	def self.find_by_credentials(username, password)
		user = User.find_by(username: username)
		return user if user && user.is_password?(password)
		nil
	end

	def self.generate_session_token
		SecureRandom::urlsafe_base64(16)
	end


	def reset_session_token!
		self.session_token = self.class.generate_session_token
		self.save!
		self.session_token
	end

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def is_password?(password)
		BCrypt::Password.new(self.password_digest).is_password?(password)
	end

	private

	def ensure_session_token
		self.session_token ||= self.class.generate_session_token
	end

end

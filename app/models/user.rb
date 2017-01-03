class User < ApplicationRecord

	validates :auth_token, uniqueness: true
	before_create :generate_auth_token!

	def generate_auth_token!
		begin
			self.auth_token = Devise.friendly_token
		end while self.class.exists?(auth_token: auth_token)
	end
end

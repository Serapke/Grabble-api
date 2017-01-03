class User < ApplicationRecord

	validates :auth_token, uniqueness: true
	validates :nickname, uniqueness: true

	before_create :generate_auth_token!
	after_create :initialize_place

	def generate_auth_token!
		begin
			self.auth_token = Devise.friendly_token
		end while self.class.exists?(auth_token: auth_token)
	end

	def initialize_place
		self.update_columns(place: id) if place.nil?
	end
end

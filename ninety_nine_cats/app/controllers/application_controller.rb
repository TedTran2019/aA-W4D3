class ApplicationController < ActionController::Base
	helper_method :current_user
	helper_method :logged_in?

	def login!(user)
		session[:session_token] = user.session_token
		@current_user = user
	end

=begin
	def logged_in?(user)
		return false if user.session_token.nil?
		session[:session_token] == user.session_token
	end
=end

	def already_signed_up
		redirect_to(cats_url) if logged_in?
	end

	def not_signed_up
		redirect_to(new_session_url) unless logged_in?
	end

	def logged_in?
		!!current_user
	end

	def current_user
		@current_user ||= User.find_by(session_token: session[:session_token])
	end

	def logout!
		current_user.reset_session_token!
		session[:session_token] = nil
		@current_user = nil
	end
end

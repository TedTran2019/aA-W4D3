class SessionsController < ApplicationController
	before_action :already_signed_up, except: [:destroy]

	def new
		@user = User.new
		render :new
	end

	# Dummy user to keep username text saved
	def create
		@user = User.new(user_params)
		@real_user = User.find_by_credentials(user_params[:username], user_params[:password])
		if @real_user
			@real_user.reset_session_token!
			login!(@real_user)
			redirect_to cats_url
		else
			flash.now[:errors] = "Incorrect credentials!"
			render :new
		end
	end

	def destroy
		if logged_in?
			logout!
			redirect_to new_session_url
		else
			flash[:errors] = "You aren't logged in!"
			redirect_to cats_url
		end
	end

	def user_params
		params.require(:user).permit(:username, :password)
	end
end

class UsersController < ApplicationController
	before_action :already_signed_up

	def new
		@user = User.new
		render :new
	end

	# Should log the user in if successful!
	def create
		@user = User.new(user_params)
		if @user.save
			login!(@user)
			redirect_to cats_url
		else
			flash.now[:errors] = @user.errors.full_messages
			render :new
		end
	end

	private

	def user_params
		params.require(:user).permit(:username, :password)
	end
end

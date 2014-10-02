class UsersController < ApplicationController
	before_action :signed_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
	before_action :correct_user_signed_in, only: [:edit, :update]
	before_action :admin_signed_in, only: [:destroy]

	def new
		@user = User.new
	end
	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end
	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the sample app!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			flash[:success] = "Settings updated successfully!"
			render 'show'
		else
			render 'edit'
		end
	end

	def index
		@users = User.paginate(page: params[:page])
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User deleted"
		redirect_to users_url
	end

	def following
		@user = User.find(params[:id])
		@title = "Following"
		@users = @user.followed_users.paginate(page: params[:page])
		render 'follow_list'
	end

	def followers
		@user = User.find(params[:id])
		@title = "Followers"
		@users = @user.followers.paginate(page: params[:page])
		render 'follow_list'
	end

	private

		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end

	  def correct_user_signed_in
	  	@user = User.find(params[:id])
	  	redirect_to root_url, notice: "You're not allowed to do that to other users!" unless current_user?(@user)
	  end

	  def admin_signed_in
	  	redirect_to(root_url) unless current_user.admin?
	  end
	  

end

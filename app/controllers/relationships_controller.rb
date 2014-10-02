class RelationshipsController < ApplicationController

	before_action :signed_in_user

	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	def destroy
		@user = User.find(Relationship.find(params[:id]).followed_id)
		#@user = current_user.followed_users.find(Relationship.find(params[:id]).followed_id)
		current_user.unfollow!(@user)
		respond_to do |format|
			format.html { redirect_to(@user) }
			format.js
		end
	end

end
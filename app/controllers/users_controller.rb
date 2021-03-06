class UsersController < ApplicationController
	
	before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
	before_action :correct_user, only: [:edit, :update]
	before_action :admin_user, only: :destroy

	def index
		#@users = User.where(activated: true).paginate(page: params[:page])
		@users = User.paginate(page: params[:page])
	end


	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			#@user.send_activation_email
			flash[:info] = I18n.t 'user.verify'
			flash[:success] = I18n.t 'home.welcome'
			#redirect_to root_url
			reset_session
			log_in @user
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
		@user.profile.attach(params[:user][:profile])
		if @user.update(user_params)
		#Handle a update
			flash[:success] = I18n.t 'user.updated'
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = I18n.t 'user.deleted'
		redirect_to users_url
	end

	def following
		@title = "Following"
		@user = User.find(params[:id])
		@users = @user.following.paginate(page: params[:page])
		render 'show_follow'
	end

	def followers
		@title = "Followers"
		@user = User.find(params[:id])
		@users = @user.followers.paginate(page: params[:page])
		render 'show_follow'
	end

	private
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile)
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		end

		# Confirms that the user is an admin
		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end
end

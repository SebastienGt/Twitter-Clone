class ApplicationController < ActionController::Base
	include SessionsHelper


	private

		# Confirm a logged in user
		def logged_in_user
			unless logged_in?
				store_location
				flash[:danger] = "S'il vous plait, connectez-vous."
				redirect_to login_url
			end
		end


		
end

class ApplicationController < ActionController::Base
	include SessionsHelper

	around_action :switch_locale

	def switch_locale(&action)
		locale = params[:locale] || I18n.default_locale
		I18n.with_locale(locale, &action)
	end

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

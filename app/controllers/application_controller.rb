class ApplicationController < ActionController::Base
	include SessionsHelper

	around_action :switch_locale

	def switch_locale(&action)
		logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
		locale = params[:locale] || extract_locale_from_accept_language_header
		logger.debug "* Locale set to '#{locale}'"
		I18n.with_locale(locale, &action)
	end
		
	
	protect_from_forgery

		def default_url_options(options={})
		logger.debug "default_url_options is passed options: #{options.inspect}\n"
		{ :locale => I18n.locale }
		end

	private

		def extract_locale_from_accept_language_header
			request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
	  	end

		# Confirm a logged in user
		def logged_in_user
			unless logged_in?
				store_location
				flash[:danger] = I18n.t 'user.pleaseConnect'
				redirect_to login_url
			end
		end

		
end

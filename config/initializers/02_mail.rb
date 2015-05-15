Rails.application.configure do
		# mailer settings
		config.action_mailer.perform_deliveries = true
		config.action_mailer.raise_delivery_errors = true
		config.action_mailer.delivery_method = :sendmail
		config.action_mailer.default_url_options = {
			:host => Problem::Settings.getValue(:email, :network_host),
			:port => Problem::Settings.getValue(:email, :network_port)
		}
end

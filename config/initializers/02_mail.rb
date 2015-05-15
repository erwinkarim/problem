Rails.application.configure do
		# mailer settings
		config.action_mailer.perform_deliveries = true
		config.action_mailer.raise_delivery_errors = true
		config.action_mailer.delivery_method = :sendmail
		config.action_mailer.default_url_options = {
			:host => ENV['email_network_host'],
			:port => ENV['email_network_port']
		}
end

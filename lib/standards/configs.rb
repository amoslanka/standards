# 
# A collection of methods that will handle parsing and setting configurations.
# Each assumes it should return a hash or other simple type, as opposed to setting 
# values on an object.
module Standards
  module Configs

    # 
    # Returns a settings object from default values and those parsed from ENV vars.
    # SMTP_ADDRESS
    # SMTP_USER_NAME
    # SMTP_PASSWORD
    # SMTP_PORT                 (default: 587)
    # SMTP_AUTHENTICATION       (default: 'plain')
    # SMTP_ENABLE_STARTTLS_AUTO
    # SMTP_OPENSSL_VERIFY_MODE
    # SMTP_DOMAIN
    def self.smtp
      settings = {
        address: ENV['SMTP_ADDRESS'],
        user_name: ENV['SMTP_USER_NAME'],
        password: ENV['SMTP_PASSWORD'],
        port: (Integer(ENV['SMTP_PORT']) rescue nil),
        authentication: ENV['SMTP_AUTHENTICATION'] || 'plain'
      }

      sendgrid = (settings[:address] == "smtp.sendgrid.net")
      gmail    = (settings[:address] == "smtp.gmail.com")

      # Specifically recognized smtp servers may have easily configured defaults, so 
      # that all that needs to be declared is address and creds.
      if settings[:port].blank? or settings[:port] == 0
        settings[:port] = if sendgrid
          25
        elsif gmail
          465
        else 
          587
        end
      end

      # Overlap SENDGRID u/p env vars
      if settings[:user_name].blank?
        settings[:user_name] = if sendgrid
          ENV["SENDGRID_USERNAME"] || ENV["SENDGRID_USER_NAME"]
        end
      end
      if settings[:password].blank?
        settings[:password] = if sendgrid
          ENV["SENDGRID_PASSWORD"]
        end
      end

      # Fallbacks and parsings when necessary
      settings[:enable_starttls_auto] = ENV['SMTP_ENABLE_STARTTLS_AUTO'] if ENV.has_key?('SMTP_ENABLE_STARTTLS_AUTO')
      settings[:openssl_verify_mode] = ENV['SMTP_OPENSSL_VERIFY_MODE'] if ENV.has_key?('SMTP_OPENSSL_VERIFY_MODE')
      settings[:domain] = ENV['SMTP_DOMAIN'] if ENV.has_key?('SMTP_DOMAIN')
      settings[:enable_starttls_auto] = false if settings[:enable_starttls_auto] == 'false'
      settings[:openssl_verify_mode] = false if settings[:openssl_verify_mode] == 'false'
      settings[:enable_starttls_auto] = true if settings[:enable_starttls_auto] == 'true'
      settings[:openssl_verify_mode] = true if settings[:openssl_verify_mode] == 'true'
      settings
    end 

  end
end
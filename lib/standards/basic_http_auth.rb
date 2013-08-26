module Standards
  module BasicHttpAuth
    # Is Enabled if the environment variables are present.
    if ENV['HTTP_USERNAME'].present? and ENV['HTTP_PASSWORD'].present?)
      Rails.application.config.middleware.insert_after(::Rack::Lock, "::Rack::Auth::Basic", Rails.env.to_s.titleize) do |u, p|
        [u, p] == [ENV['HTTP_USERNAME'], ENV['HTTP_PASSWORD']]
      end
    end
  end
end
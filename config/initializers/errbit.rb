if Rails.env.production?
  Airbrake.configure do |config|
    config.api_key = "d05eff2bdbf9286c136f059aa8442883"
    config.host    = "errbit.oleander.io"
    config.port    = 80
    config.secure  = config.port == 443
  end
end
set :domain, "radiofy.se"
set :deploy_to, "/opt/www/echoprint.oleander.io"
set :pty, true

server("radiofy.se", {
  user: "webmaster",
  roles: ["web", "app", "db"],
  ssh_options: {
    keys: %w(~/.ssh/id_rsa),
    forward_agent: true,
    port: 2424,
    paranoid: false
  }
}) 

set :rvm_type, :webmaster
set :rvm_ruby_version, "ruby-2.1.5"
lock "3.3.5"

set :application, "radiofy.se"
set :repo_url, "git@github.com:oleander/echoprint-rb.git"
set :branch, "master"

role :web, fetch(:application)
role :app, fetch(:application)
role :db, fetch(:application)

set :log_level, :debug

set :linked_dirs, [
  "public/system",
  "log",
  "tmp"
]

set :linked_files, [
  "config/database.yml",
]

namespace :deploy do 
  task :reload do
    on roles(:web) do
      execute "sudo god load #{current_path}/config/unicorn.god"
    end
  end

  task :restart do
    on roles(:web) do
      execute "sudo god restart echonest-unicorn"
    end
  end

  after "deploy:publishing", "deploy:reload"
  after "deploy:reload", "deploy:restart"
end
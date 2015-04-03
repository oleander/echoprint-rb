rails_root = File.expand_path("../..", __FILE__)

God.watch do |w|
  w.name = "echonest-unicorn"
  w.interval = 30.seconds

  w.env = {
    "BUNDLE_GEMFILE" => "#{rails_root}/Gemfile"
  }

  w.start = "bbundle4 exec unicorn -c #{File.join(rails_root, "config/unicorn.rb")} -E production -D"
  w.stop = "kill -QUIT `cat #{rails_root}/log/unicorn.pid`"
  w.restart = "kill -USR2 `cat #{rails_root}/log/unicorn.pid`"

  w.start_grace = 10.seconds
  w.restart_grace = 1.minute
  w.pid_file = "#{rails_root}/log/unicorn.pid"
  w.log = "#{rails_root}/log/unicorn.log"

  w.uid = "webmaster"

  w.keepalive
end
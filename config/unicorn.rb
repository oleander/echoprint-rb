root = File.expand_path("../../", __FILE__)
working_directory root
pid File.join(root, "log/unicorn.pid")
stderr_path File.join(root, "log/unicorn.log")
stdout_path File.join(root, "log/unicorn.log")
listen File.join(root, "log/unicorn.sock"), backlog: 64
worker_processes 2
timeout 30
preload_app true

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = File.join(root, "log/unicorn.pid.oldbin") 
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
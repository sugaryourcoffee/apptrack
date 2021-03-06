set :application, 'apptrack'
set :repo_url, 'git@github.com:sugaryourcoffee/apptrack.git'
set :branch, 'master'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/apptrack'
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

#set :linked_files, %w{config/database.yml}
#set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

#set :default_env, { path: "/home/pierre/.rvm/gems/ruby-2.0.0-p643@rails401:$PATH" }
set :keep_releases, 5

namespace :setup do
  desc "Upload database.yml to config/database.yml on the server"
  task :upload_database_yml do
    on roles(:app) do
      execute :mkdir, '-p', shared_path.join('config')
      upload! StringIO.new(File.read("config/database.yml")), 
              shared_path.join('config/database.yml')
    end
  end
end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end


  desc 'Copy database.yml file into the latest release'
  task :copy_database_yml do
    on roles(:app) do
      unless test("[ -f #{shared_path}/config/database.yml ]")
        execute :mkdir, '-p', shared_path.join('config')
        upload! StringIO.new(File.read("config/database.yml")),
                shared_path.join('config/database.yml')
      end
      execute :cp, shared_path.join('config/database.yml'), 
                   release_path.join('config/')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'tmp:clear'
      end
    end
  end
  
  before :updated, 'deploy:copy_database_yml'
  after :finishing, 'deploy:cleanup'
end


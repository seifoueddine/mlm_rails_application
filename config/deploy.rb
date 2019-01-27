
# Change these
server '51.38.231.157', roles: [:web, :app, :db], primary: true

set :repo_url,        'git@github.com:seifoueddine/aylis.git'
set :application,     'aylis'
set :user,            'aylis'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord


#set :rvm_type, :system                     # Defaults to: :auto
#set :rvm_ruby_version, 'ruby-2.4.1@aylis'      # Defaults to: 'default'

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end


  set :linked_dirs, fetch(:linked_dirs, []).push('public/system')
   set :assets_dependencies, %w(app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb)
   Rake::Task["deploy:assets:precompile"].clear_actions
   class PrecompileRequired < StandardError; end


=begin

  namespace :paperclip do
    desc "build missing paperclip styles"
    task :build_missing_styles do
      on roles(:app) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, "paperclip:refresh:missing_styles"
          end
        end
      end
    end
  end

  after("deploy:compile_assets", "paperclip:build_missing_styles")
=end


=begin
  before 'deploy:update_code', 'thinking_sphinx:stop'
  after  'deploy:update_code', 'thinking_sphinx:start'

  namespace :sphinx do
    desc "Symlink Sphinx indexes"
    task :symlink_indexes, :roles => [:app] do
      run "ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
    end
  end

  after 'deploy:finalize_update', 'sphinx:symlink_indexes'
=end


  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  #after  :finishing,    :restart
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
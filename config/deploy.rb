require 'bundler/capistrano'
require 'dotenv'
Dotenv.load

set :application, 'rmxs'
set :repository, ENV['CAP_REPOSITORY']
set :branch, ENV['CAP_BRANCH']

role :web, ENV['CAP_SERVER']
role :app, ENV['CAP_SERVER']
role :db, ENV['CAP_SERVER'], :primary => true

set :use_sudo, false
set :deploy_to, ENV['CAP_DEPLOY_TO']
set :deploy_via, :remote_cache
set :git_enable_submodules, true
set :git_shallow_clone, 1
set :scm_verbose, true
set :ssh_options, { :forward_agent => true }
set :bundle_without, [:development, :test]
set :normalize_asset_timestamps, false

after 'deploy:create_symlink', 'deploy:symlink_attachment'
namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    sudo '/etc/init.d/httpd restart', :pty => true
  end

  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    sudo '/etc/init.d/httpd restart', :pty => true
  end

  task :symlink_attachment, :roles => :app, :except => { :no_release => true } do
    run "rm -rf #{current_path}/config/kyary_rmx && ln -fs #{shared_path}/config/kyary_rmx #{current_path}/config/kyary_rmx"
    run "rm -rf #{current_path}/public/wp-config && ln -fs #{shared_path}/public/wp-config #{current_path}/public/wp-config"
    run "ln -fs #{shared_path}/public/wp-content/uploads #{current_path}/public/wp-content/uploads"
  end
end


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
  task :start, :roles => :web, :except => { :no_release => true } do
    sudo '/etc/init.d/httpd restart', :pty => true
  end

  task :stop do ; end

  task :restart, :roles => :web, :except => { :no_release => true } do
    sudo '/etc/init.d/httpd restart', :pty => true
  end

  task :symlink_attachment, :roles => :web, :except => { :no_release => true } do
    run "ln -fs #{shared_path}/config/prfm_rmx #{current_path}/config/prfm_rmx"
    run "ln -fs #{shared_path}/config/ystk_rmx #{current_path}/config/ystk_rmx"
    run "ln -fs #{shared_path}/config/mflo_rmx #{current_path}/config/mflo_rmx"
    run "ln -fs #{shared_path}/config/kyary_rmx #{current_path}/config/kyary_rmx"
    run "rm -rf #{current_path}/public/wp-config && ln -fs #{shared_path}/public/wp-config #{current_path}/public/wp-config"
    run "ln -fs #{shared_path}/public/wp-content/uploads #{current_path}/public/wp-content/uploads"
  end
end

namespace :config do
  namespace :deploy do
    set :local_config_path, File.expand_path('../../config', __FILE__)
    set :remote_config_path, "#{shared_path}/config"

    task :default, :roles => :web do
      transaction do
        on_rollback do
          Dir.glob("#{local_config_path}/*").each do |dir|
            next unless File::ftype(dir) == 'directory'
            remote_dir = "#{remote_config_path}/#{File.basename(dir)}"
            run "rm -rf #{remote_dir}"
            run "cp -rf #{remote_dir}.prev #{remote_dir}"
          end
        end
        update
      end
    end

    task :update, :roles => :web do
      Dir.glob("#{local_config_path}/*").each do |dir|
        next unless File::ftype(dir) == 'directory'
        remote_dir = "#{remote_config_path}/#{File.basename(dir)}"
        run "rm -rf #{remote_dir}.prev"
        run "cp -rf #{remote_dir} #{remote_dir}.prev"
        Dir.glob("#{dir}/{WHITELIST,BLACKLIST}").each do |file|
          upload(file, remote_dir, :via => :scp)
        end
      end
    end
  end
end

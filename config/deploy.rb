require 'bundler/capistrano'

set :whenever_command, 'bundle exec whenever'
set :whenever_environment, defer { rails_env }
set :whenever_identifier, defer { "#{application}_#{rails_env}" }
require 'whenever/capistrano'

#adds our ssh keys to the forwarding agent
`ssh-add`

set :application, 'likelist'
set(:deploy_to) { "/home/apps/#{application}_#{rails_env}" }

set :user, 'deploy'

set :repository, 'git@github.com:adamvduke/Like.it.git'
set :branch, 'master'
set :domain, 'www.likelist.me'

set :scm, :git
set :scm_verbose, true
set :deploy_via, :remote_cache

set :use_sudo, false
ssh_options[:forward_agent] = true

# bundler options
set :bundle_flags, '--deployment --binstubs'
set :bundle_without, [:test, :development]

#rbenv
default_run_options[:shell] = '/bin/bash --login'

role :web, domain
role :app, domain
role :db,  domain, :primary => true # This is where Rails migrations will run

after 'deploy:create_symlink', 'config:symlink'
after 'deploy:cold', 'config:application'
after 'deploy:setup', 'config:setup', 'logs:symlink'
before 'deploy:migrate', 'config:symlink'
before 'deploy:assets:precompile', 'config:symlink'

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do
    run "sudo sv start likelist_#{rails_env}"
    run "sudo sv start sidekiq_#{rails_env}"
  end
  task :stop do
    run "sudo sv stop likelist_#{rails_env}"
    run "sudo sv stop sidekiq_#{rails_env}"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo sv restart likelist_#{rails_env}"
    run "sudo sv restart sidekiq_#{rails_env}"
  end

  desc 'Show deployed revision'
  task :revision, :roles => :app do
    run "cat #{current_release}/REVISION"
  end
end

namespace :config do
  task :setup do
    run "if ! [ -d #{shared_path}/config ]; then mkdir #{shared_path}/config; fi"
  end

  desc 'prompts for every value in application.yml.example'
  task :application do
    settings = YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/application.yml.example')
    settings = settings.map do |key, value|
      [key, Capistrano::CLI.ui.ask(key)]
    end
    settings = Hash[settings]

    put YAML.dump(settings), "#{shared_path}/config/application.yml"
  end

  task :database do
    template = <<YAML
#{rails_env}:
  adapter: postgresql
  database: likelist_#{rails_env}
  username: likelist
  password: #{Capistrano::CLI.password_prompt('database password')}
  host: localhost
  pool: 5
  timeout: 5000
YAML

    put template, "#{shared_path}/config/database.yml"
  end

  task :symlink, :except => { :no_release => true } do
    %w[database application].each do |config_file|
      run "ln -nfs #{shared_path}/config/#{config_file}.yml #{release_path}/config/#{config_file}.yml"
    end
  end
end

namespace :logs do
  task :symlink do
    %w[access error].each do |type|
      run "ln -nfs /var/log/nginx/likelist_#{rails_env}-#{type}.log #{shared_path}/log"
    end
  end
end

task :staging do
  set :rails_env, 'staging'
end

task :production do
  set :rails_env, 'production'
end

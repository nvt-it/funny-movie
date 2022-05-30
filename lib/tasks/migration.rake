# frozen_string_literal: true

namespace :migration do
  desc 'Apply database schema allow drop table put ALLOW_DROP_TABLE or allow remove column put ALLOW_REMOVE_COLUMN'
  
  task apply: :environment do
    ridgepole("--apply --allow-pk-change --file '#{schema_file}'")
    Rake::Task['db:schema:dump'].invoke

    execute 'bundle exec annotate --models --exclude fixtures,specs'
  end
end

private

def schema_file
  Rails.root.join('db/Schemafile')
end

def database_yml
  Rails.root.join('config/database.yml')
end

def ridgepole(options)
  execute ['bundle exec ridgepole', "--config '#{database_yml}'", env_option, options].join(' ')
end

def env_option
  op = []
  op << "--env #{ENV['RAILS_ENV']}" if ENV['RAILS_ENV'].present?
  op
end

def execute(command)
  puts command
  system command
end

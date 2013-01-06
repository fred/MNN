#!/bin/env ruby
require 'yaml'

namespace :db do
  task :pull => :environment do
    db_config = Rails.application.config.database_configuration[Rails.env]
    rsync_config = YAML.load_file(File.join(Rails.root, "config", "rsync.yml"))
    db_config = Rails.application.config.database_configuration[Rails.env]
    puts "Syncing from server"
    sh "rsync -av --exclude='#{Time.now.year}/#{Time.now.month-1}' #{rsync_config['rsync_url']}:#{rsync_config['remote_dir']} #{rsync_config['local_dir']}"
    @last_restore=`find #{rsync_config['local_dir']} -type f -name full_mnn_production_*.sql.gz | tail -n1`.strip
    puts "Dropping DB"
    Rake::Task['db:drop'].invoke
    puts "Creating DB"
    Rake::Task['db:create'].invoke
    puts "Migrating DB"
    Rake::Task['db:migrate'].invoke
    puts "Truncating DB"
    sh "psql -d #{db_config['database']} -a -f db/truncate.sql"
    puts "Restoring Last Dump"
    sh "pg_restore -C -d #{db_config['database']} #{@last_restore}"
    puts "Reindexing Solr"
    Rake::Task["sunspot:reindex"].invoke
  end
end

require 'digest'

desc "Prepare the application for development"
task :setup => %w(config/database.yml config/session.yml)

desc <<DESC
Generate a config file for your databases.
It will generate a bog standard database config file to use SQLite3, unless
you specify a different adapter with "config/database.yml[mysql]"
DESC
file 'config/database.yml', :adapter do |t, args|
  include Base64
  include Digest
  config = {}
  %w(development test production).each do |env|
    config[env] = {}
    case config[env]['adapter'] = args[:adapter] || 'sqlite3'
      when 'sqlite3' then config[env]['database'] = "db/#{env}.sqlite3"
      when 'sqlite' then config[env]['database'] = "db/#{env}.sqlite"
      when 'mysql'
        config[env]['database'] = "danlann_#{env}"
        config[env]['host'] = "localhost"
        config[env]['username'] = "danlann"
        password = encode64(SHA1.digest("#{rand}Dánlann#{Time.now}"))[0..8]
        config[env]['password'] = password
        puts "Now set up your MySQL database and update config/database.yml"
      else raise "Unsupported database #{args[:adapter]}..."
    end
  end
  File.open(t.name, 'w') { |f| YAML.dump(config, f) }
end

desc <<DESC
Generate a unique secret session key.
Use "rake config/session.yml[blah]" to name your session cookie
"blah_session"
DESC
file 'config/session.yml', :name do |t, args|
  name = args.name || "danlann"
  config = {
    "session_key" => "#{name}_session",
    "key" => ActiveSupport::SecureRandom.hex(64)
  }
  File.open(t.name, 'w') { |f| YAML.dump(config, f) }
end

namespace :db do
  desc "Fill the database with data for testing"
  task :populate => :environment do |t|
    require 'open-uri'
    include Faker
    flickr = "http://www.flickr.com"
    (20 - User.count).times do
      User.new do |user|
        user.email = Internet.email
        user.password = "secret"
        user.password_confirmation = "secret"
      end
    end
    tags = Lorem::words(10)
    Dir["test/fixtures/**/*.jpg"].each do |f|
      User.all.each do |user|
        # TODO
      end
    end
  end
end

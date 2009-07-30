require 'digest'

desc <<-DESC
Prepare the application for development (or deployment).
DESC
task :setup do |t, args|
end

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

namespace :page do
  desc "Clean out cached files in public/"
  task :clear do
    %w(pictures tags users).each do |controller|
      directory = File.join(Rails.root, controller)
      Dir.rmdir(directory) if File.directory?(directory)
    end
  end
end

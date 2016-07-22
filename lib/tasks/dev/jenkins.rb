require 'ci/reporter/rake/rspec'

Rake::Task["ci:setup:spec_report_cleanup"].clear

namespace :ci do
  namespace :setup do
    task :spec_report_cleanup do
      dir = ENV["CI_REPORTS"] || "spec/reports"
      rm_rf dir unless File.symlink?(dir)
    end
  end
end

namespace :jenkins do
  require 'cucumber'
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = "--tags ~@wip --format pretty --format junit --out features/reports"
  end

  task :rspec => ['ci:setup:rspec', :spec]
end

task :jenkins => ['db:migrate', 'jenkins:rspec', 'jenkins:cucumber']